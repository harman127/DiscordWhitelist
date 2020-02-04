----------------------------------------
--- Discord Whitelist, Made by FAXES ---
----------------------------------------

--- Config ---
notWhitelisted = "You are not whitelisted for this server." -- Message displayed when they are not whitelist with the role
noDiscord = "You must have Discord open to join this server." -- Message displayed when discord is not found
debug = false


roles = { -- Role nickname(s) needed to pass the whitelist
    "Role1",
    "Role2",
    "Role3",
}


--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local role_found = false
    local src = source
    deferrals.defer()
    deferrals.update("Checking Permissions")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
            if debug then
                deferrals.update("Discord ID found. Requesting check with discord_perms.")
            end
        end
    end

    if identifierDiscord then
        for i = 1, #roles do
            if debug then
                deferrals.update("Checking to see if user has "..roles[i])
            end
            if exports.discord_perms:IsRolePresent(src, roles[i]) then
                role_found = true
            end
        end
        if role_found then
            deferrals.done()
        else
            deferrals.done(notWhitelisted)
        end
    else
        deferrals.done(noDiscord)
    end
end)