vim.g.db_ui_use_nerd_fonts = 1
-- Example Connection
-- vim.g.dbs = {
--     { name = 'local database 1', url = 'mysql://username:password@localhost:3306/local_database_1' },
--     { name = 'local database 2', url = 'mysql://username:password@localhost:3306/local_database_2' },
-- }


local function exists(name)
    local ok, err, code = os.rename(name, name)
    if not ok then
        if code == 13 then
            -- Permission, denies, but it exists
            return true
        end
    end
    return ok, err
end

local function isdir(path)
    return exists(path.."/")
end

local function require_if_exists(path, packagename)
    if isdir(path) and exists(path.."/"..packagename..".lua") then
        package.path = package.path..";"..path.."/?.lua;"
        require(packagename)
    end
end

-- Import databases from uncommitted local file
local dbConnectionConfigPath = os.getenv("HOME") .. "/.dbuiconnections"
local dbConnectionConfigPackage = "connections"

require_if_exists(dbConnectionConfigPath, dbConnectionConfigPackage)

