local function easy_secret(name)
    local handle = io.popen("easy-secret " .. name)
    local stdout = handle:read("*a")
    local ok, _, code = handle:close()
    if not ok or code ~= 0 then
        os.exit(1)
    end
    return stdout
end

local acc_bsc = IMAP {
    server = "mail.bsc.es",
    username = "fayats",
    password = easy_secret("bsc-password"),
    ssl = "auto",
}

print("Mailboxes:")
local res = acc_bsc:list_all()
for _, v in ipairs(res) do
    print(v)
end

function print_messages(msgs)
    for _, message in ipairs(msgs) do
        local mailbox, uid = table.unpack(message)
        print(mailbox[uid]:fetch_field("Subject"))
    end
end

local gitlab_msgs = acc_bsc.INBOX:contain_from("gitlab@gitlab.bsc.es")
gitlab_msgs:mark_seen()
gitlab_msgs:move_messages(acc_bsc.GitLab)

acc_bsc.INBOX:contain_subject("[Personal]"):move_messages(acc_bsc.Archives)
acc_bsc.INBOX:contain_subject("[BSC-CNS]"):move_messages(acc_bsc.Archives)
acc_bsc.INBOX:contain_subject("BSC Intranet:"):move_messages(acc_bsc.Archives)

-- print_messages(acc_bsc.INBOX:select_all())
