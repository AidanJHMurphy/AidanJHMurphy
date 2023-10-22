#!/bin/sh

# Helper functions for parsing ini files
source ./bash-ini-parser

# TODO: Add success messages to verbose screen output

###################
# Mount smb share #
# Arguments:
#   $1 label
#   $2 host
#   $3 share name
#   $4 username
#   $5 workgroup
#   $6 password
# Returns:
#   label_mount_loc - A variable storing the mount location of the SMB drive
#                      where "label" is replaced with the one passed in
###################
smb_mount_loc_format="/run/user/$UID/gvfs/smb-share:server=%s,share=%s"
smb_mount_address_format="smb://%s/%s"
mount_smb() {
    # TODO: Get rid of this indirection nonsense, and just store the values
    #  in an array indexed by the label and data type (rudimentary map)
    local label_mount_loc
    printf -v label_mount_loc '%s' "${1}_mount_loc"
    printf -v $label_mount_loc $smb_mount_loc_format $2 $3

    local label_mount_address
    printf -v label_mount_address '%s' "${1}_label_mount_address"
    printf -v $label_mount_address $smb_mount_address_format $2 $3
    
    if [ "$mode" = "mount" ]; then
        output="$({ echo $4; echo $5; echo $6; } | gio mount "${!label_mount_address}" 2>&1)"
        exit_code=$?

        if [ $exit_code = 0 ]; then
            # There's some kind of race condition where gio exits, and the
            # share gets mounted, but isn't visible to checks on whether
            # the mount location exists.
            # Instead store off whether gio lists the mount for use by the
            # safe link function, and trust that even if it's broken now,
            # it will be a valid link soon(-ish)
            local label_mount_success
            printf -v label_mount_success '%s' "${1}_mount_success"
            printf -v $label_mount_success '%d' $(gio mount --list | grep ${!label_mount_address} | wc -l)
        elif [ "$verbose" = true ]; then
            echo "not mounting ${1}: " $output
        fi
    elif [ "$mode" = "unmount" ]; then
        output="$(gio mount -u "smb://${2}/${3}" 2>&1)"
        exit_code=$?

        if [ ! $exit_code = 0 ] && [ "$verbose" = true ]; then
            echo "not unmounting ${1}: " $output
        fi
    fi
}

#################
# Soft link a file to a target.
# Overwrites broken links, but skips if the target already exists.
# Skips if the source file doesn't exist.
# Skips if a target isn't provided.
# Creates directories as needed to create link
# Arguments:
#   $1 The existing file being linked onto the target
#   $2 The target directory of the link
#   $3 The name of the new target file (optional)
#
################
safe_link() {
    # proceed with linking if a link target is specified,
    if [ -n $2 ]; then

        link_target="${2}/"

        # set link target name based on whether a new name was given
        if [ -n $3 ]; then
            link_target="${2}/${3}"
        # Otherwise 
        else
            link_target="${2}/$(basename -z $1)"
        fi

        if [ "$mode" = "mount" ]; then
            # Don't link over an existing file
            if [ ! -e  $link_target ]; then
                # Ensure target destination directory exists
                mkdir -p $2

                # Use force to allow overwriting existing broken links
                ln -sf -T $1 $link_target
            elif [ "$verbose" = true ]; then
                echo "did not soft link $1 to $link_target: file exists"
            fi
        elif [ "$mode" = "unmount" ]; then
            # only remove broken soft links
            if [ -L $link_target ]; then
                if [ ! -e $link_target ]; then
                    rm $link_target
                elif [ "$verbose" = true ]; then
                    echo "Not removing valid soft link $link_target"
                fi
            fi
        fi
    fi
}

###############
# Validate that an element is a member of an array
# Arguments
#   $1 name of array variable
#   $2 element to seek
##############
array_contains () { 
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

## usage documentation
usage() {
    echo "Usage: mountdrive MODE INI-FILE [OPTION]..."
    echo "  or:  mountdrive MODE INI-FILE LABEL [OPTION]..."
    echo ""
    echo "Mounts or unmounts the drives specified in the ini file."
    echo ""
    echo "  MODE:              Either \"mount\" or \"unmount\""
    echo "  INI-FILE:          Path to a ini config file"
    echo "  LABEL (optional):  Specific label from INI-FILE"
    echo "                       If specified, only mounts or unmounts this share"
    echo ""
    echo "OPTIONS:"
    echo "  -v, --verbose      prints messages to the screen"
    echo "  -h, --help         display this help and exit"
    echo ""
    echo " TODO: Describe the form of INI-FILE, and DEFAULT label"
}

# parse parameters
params="$(getopt -o "hvl:" -l "help,verbose,label:" -- "$@")"
eval set -- "$params"

# set defaults
verbose=false

for opt; do
    case "$1" in
        "-h"|"--help")
            usage
            exit 0
            ;;
        "-v"|"--verbose")
            verbose=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Not implemented: $1" >&2
            exit 1
            ;;
    esac
done

mode=${1}
ini_file=${2}
label=${3}

# Parameter Validation

# Validate Mode
if [ ! "$mode" = "mount" ] && [ ! "$mode" = "unmount" ]; then
    echo "mode must be \"mount\" or \"unmount\""
    usage
    exit 1
fi

# Ensure ini file exists
if [ -z $ini_file ]; then
    echo "ini-file is required"
    usage
    exit 1
fi

if [ ! -r $ini_file ]; then
    echo "No such file: ${ini_file}"
    exit 1
fi

cfg_parser "${ini_file}"

# ensure specified label is a section in the given ini file
if [ ! -z $label ]; then
    valid_label=$(array_contains section_list $label && echo 0 || echo 1)
    if [ ! $valid_label -eq 0 ]; then
        echo "invalid ini label: ${label}"
        exit 1
    fi
fi

# generic reset values to empty string
default_mount_type=""
default_mount_host=""
default_mount_share=""
default_mount_user=""
default_mount_domain=""
default_mount_password=""
default_link_directory=""
default_link_name=""

# save off values if a default config is used
# save off non-DEFAULT sections to mount
for element in "${section_list[@]}"; do
    if [[ $element == "DEFAULT" ]]; then
        cfg_section_DEFAULT
        default_mount_type=$mount_type
        default_mount_host=$mount_host
        default_mount_share=$mount_share
        default_mount_user=$mount_user
        default_mount_domain=$mount_domain
        default_mount_password=$mount_password
        default_link_directory=$link_directory
        default_link_name=$link_name
    else
        shares_to_mount+=( $element )
    fi
done

# overwrite sections to mount if one is specified
if [ ! -z $label ]; then
    unset shares_to_mount 
    shares_to_mount[0]=$label
fi

#################
# Pull config from ini for a given label
# using specified default values
# Arguments:
#   $1 section label from the ini
get_mount_config() {
    mount_type=$default_mount_type
    mount_host=$default_mount_host
    mount_share=$default_mount_share
    mount_user=$default_mount_user
    mount_domain=$default_mount_domain
    mount_password=$default_mount_password
    link_directory=$default_link_directory
    link_name=$default_link_name

    config_read_function="cfg_section_${1}"
    $config_read_function
}

# Finally mount drives and link
for mount_label in "${shares_to_mount[@]}"; do
    get_mount_config $mount_label
   
    # Mount based on config
    case $mount_type in
        "SMB")
            mount_smb "${mount_label}" "${mount_host}" "${mount_share}" "${mount_user}" "${mount_domain}" "${mount_password}"
            ;;
        "*")
            if [ "$verbose" -eq true ]; then
                echo "unsupported mount type: ${mount_type}"
            fi
            ;;
    esac

    # Store off mount location, and create link based on config
    mount_location=$(tmp="${mount_label}_mount_loc"; echo ${!tmp})
    mount_success=$(tmp="${mount_label}_mount_success"; echo ${!tmp})
    if [ "${mode}" = "unmount" ] || [ $mount_success -eq 1 ]; then
        safe_link $mount_location $link_directory "${link_name}"
    fi
done

exit 0
