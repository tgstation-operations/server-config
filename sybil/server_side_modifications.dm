/client/var/forumlinklimit = 0
/client/verb/linkforumaccount()
    set category = "OOC"
    set name = "Link Forum Account"
    set desc = "Validates your byond account to your forum account. Required to post on the forums."

    if (forumlinklimit > world.time + 100)
        to_chat(src, {"<span class="userdanger">Please wait 10 game seconds between forums link attempts.</span>"})
        return

    forumlinklimit = world.time

    if (!SSdbcore.Connect())
        to_chat(src, {"<span class="danger">No connection to the database.</span>"})
        return

    if  (is_guest_key(ckey))
        to_chat(src, {"<span class="danger">Guests can not link accounts.</span>"})

    var/token = generate_account_link_token()

    var/datum/db_query/query_set_token = SSdbcore.NewQuery("INSERT INTO phpbb.tg_byond_oauth_tokens (`token`, `key`) VALUES (:token, :key)", list("token" = token, "key" = key))
    if(!query_set_token.Execute())
        to_chat(src, {"<span class="danger">Unknown error #3.</span>"})
        qdel(query_set_token)
        return

    qdel(query_set_token)

    to_chat(src, {"Now opening a window to login to your forum account, Your account will automatically be linked the moment you log in. If this window doesn't load, Please go to <a href="https://tgstation13.org/phpBB/linkbyondaccount.php?token=[token]">https://tgstation13.org/phpBB/linkbyondaccount.php?token=[token]</a> This link will expire in 30 minutes."})
    src << link("https://tgstation13.org/phpBB/linkbyondaccount.php?token=[token]")

/client/proc/generate_account_link_token()
    var/static/entropychain
    if (!entropychain)
        if (fexists("data/entropychain.txt"))
            entropychain = file2text("entropychain.txt")
        else
            entropychain = "LOL THERE IS NO ENTROPY #HEATDEATH"
    else if (prob(rand(1,15)))
        text2file("data/entropychain.txt", entropychain)

    #define RANDOM_STRING "SHA2(CONCAT(RAND(),UUID(),?,RAND(),UUID()), 512)"
    #define RANDOM_STRING_ARGS "[entropychain][GUID()][rand()*rand(999999)][world.time][GUID()][rand()*rand(999999)][world.timeofday][GUID()][rand()*rand(999999)][world.realtime][GUID()][rand()*rand(999999)][time2text(world.timeofday)][GUID()][rand()*rand(999999)][world.tick_usage][computer_id][address][ckey][key][GUID()][rand()*rand(999999)]"
    var/datum/db_query/query_get_token = SSdbcore.NewQuery("SELECT [RANDOM_STRING], [RANDOM_STRING]", list(RANDOM_STRING_ARGS, RANDOM_STRING_ARGS))

    if(!query_get_token.Execute())
        to_chat(src, {"<span class="danger">Unknown error #1.</span>"})
        qdel(query_get_token)
        return

    if(!query_get_token.NextRow())
        to_chat(src, {"<span class="danger">Unknown error #2.</span>"})
        qdel(query_get_token)
        return

    . = query_get_token.item[1]

    entropychain = "[query_get_token.item[2]]"