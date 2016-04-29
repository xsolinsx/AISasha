--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------

local LANG = 'IT'

local function run(msg, matches)
    if is_sudo(msg) then
        -------------
        -- Plugins --
        -------------

        -- global --
        set_text('require_sudo', '🚫 Questo comando richiede i privilegi di sudo.')
        set_text('require_admin', '🚫 Questo comando richiede privilegi da admin o superiori.')
        set_text('require_owner', '🚫 Questo comando richiede privilegi da owner o superiori.')
        set_text('require_mod', '🚫 Questo comando richiede privilegi da moderatore o superiori.')
        set_text('errorTryAgain', 'Errore, prova di nuovo.')
        set_text('opsError', 'Ops, errore.')
        set_text('useYourGroups', 'Usalo nei tuoi gruppi!')
        set_text('cantKickHigher', 'Non puoi rimuovere un mod/owner/admin/sudo!')
        set_text('user', 'Utente ')
        set_text('kicked', ' rimosso.')
        set_text('banned', ' bannato.')
        set_text('unbanned', ' unbannato.')
        set_text('gbanned', ' bannato globalmente.')
        set_text('ungbanned', ' unbannato globalmente.')

        -- seedbot.lua --
        set_text('sender', 'Mittente: ')
        set_text('receiver', 'Ricevente: ')
        set_text('msgText', 'Testo del messaggio: ')

        -- utils.lua --
        set_text('errorImageDownload', 'Errore nel download dell\'immagine.')
        set_text('banListStart', 'Lista ban:\n\n')
        set_text('gbanListStart', 'Lista ban globali:\n\n')
        set_text('mutedUsersStart', 'Utenti muti di:')
        set_text('mutedTypesStart', 'Muti di:')
        set_text('mute', 'Muto ')
        set_text('alreadyEnabled', ' già attivato.')
        set_text('enabled', ' attivato.')
        set_text('alreadyDisabled', ' già disattivato.')
        set_text('disabled', ' disattivato')
        set_text('noAutoKick', 'Non puoi rimuoverti da solo.')
        set_text('noAutoBan', 'Non puoi bannarti da solo.')

        -- admin.lua --
        set_text('sendNewPic', 'Mandami la nuova foto.')
        set_text('botPicChanged', 'Foto cambiata!')
        set_text('logSet', 'Il log è stato aggiunto.')
        set_text('logUnset', 'Il log è stato rimosso.')
        set_text('markRead', 'Segna come già letto')
        set_text('pmSent', 'Messaggio mandato')
        set_text('cantBlockAdmin', 'Non puoi bloccare un admin.')
        set_text('userBlocked', 'Utente bloccato.')
        set_text('userUnblocked', 'Utente sbloccato.')
        set_text('contactListSent', 'Ti ho mandato in privato la lista dei contatti nel formato da te richiesto.')
        set_text('removedFromContacts', ' rimosso dai contatti.')
        set_text('addedToContacts', ' aggiunto ai contatti.')
        set_text('contactMissing', 'Non ho il tuo numero di telefono!')
        set_text('chatListSent', 'Ti ho mandato in privato la lista delle chat nel formato da te richiesto.')
        set_text('gbansSync', 'Lista ban globali sincronizzata.')
        set_text('longidUpdate', 'Aggiorna long_ID.')
        set_text('alreadyLog', 'Già un gruppo di log.')
        set_text('notLog', 'Non un gruppo di log.')
        set_text('backupDone', 'Backup eseguito, ti invio il log in privato.')

        -- anti_spam.lua --
        set_text('blockedForSpam', ' bloccato (SPAM).')
        set_text('floodNotAdmitted', 'Il flood non è ammesso.\n')
        set_text('statusRemoved', 'Utente rimosso.')
        set_text('gbannedFrom', ' bannato globalmente da ')

        -- arabic_lock.lua --
        set_text('arabicNotAllowed', 'L\'arabo/Il persiano non è ammesso.\n')
        set_text('statusRemovedMsgDeleted', 'Utente rimosso/messaggio eliminato.')

        -- banhammer.lua --
        set_text('noUsernameFound', 'Non trovo nessun utente con quell\'username.')

        -- bot.lua --
        set_text('botOn', 'Sono tornata. 😏')
        set_text('botOff', 'Nulla da fare qui. 🚀')

        -- feedback.lua --
        set_text('feedStart', '@EricSolinas hai ricevuto un feedback: #newfeedback\n\nMittente')
        set_text('feedName', '\nNome: ')
        set_text('feedSurname', '\nCognome: ')
        set_text('feedUsername', '\nUsername: @')
        set_text('feedSent', 'Feedback inviato!')

        -- filemanager.lua --
        set_text('backHomeFolder', 'Sei tornato alla cartella base: ')
        set_text('youAreHere', 'Sei qui: ')
        set_text('folderCreated', 'Cartella \'X\' creata.')
        set_text('folderDeleted', 'Cartella \'X\' eliminata.')
        set_text('fileCreatedWithContent', ' creato con \'X\' come contenuto.')
        set_text('copiedTo', ' copiato in ')
        set_text('movedTo', ' spostato in ')
        set_text('sendingYou', 'Ti sto inviando ')
        set_text('useQuoteOnFile', 'Usa \'rispondi\' sul file che vuoi che scarichi.')
        set_text('needMedia', 'Mi serve un file.')
        set_text('mediaNotRecognized', 'File non riconosciuto.')
        set_text('fileDownloadedTo', 'File scaricato in: ')
        set_text('errorDownloading', 'Errore durante il download: ')

        -- flame.lua --
        set_text('cantFlameHigher', 'Non puoi flammare un mod/owner/admin/sudo/!')
        set_text('noAutoFlame', 'Non posso flammarmi da sola trisomico del cazzo!')
        set_text('hereIAm', 'Eccomi qua!')
        set_text('stopFlame', 'Si si mi fermo però porca madonna.')
        set_text('flaming', 'Sto flammando: ')
        set_text('errorParameter', 'Errore variabile redis mancante.')

        -- help.lua --
        set_text('require_higher', '🚫 Questo plugin richiede privilegi superiori a quelli che possiedi.\n')
        set_text('pluginListStart', 'ℹ️Lista plugin: \n\n')
        set_text('helpInfo', 'ℹ️Scrivi "!help <plugin_name>|<plugin_number>" per maggiori informazioni su quel plugin.\nℹ️O "!helpall" per mostrare tutte le informazioni.')
        set_text('errorNoPlugin', 'Questo plugin non esiste o non ha una descrizione.')
        set_text('doYourBusiness', 'Ma una sportina di cazzi tuoi no?')
        set_text('helpIntro', 'Ogni \'#\' può essere sostituito con i simboli \'/\' o \'!\'.\nTutti i comandi sono Case Insensitive.\nLe parentesi quadre significano opzionale.\nLe parentesi tonde indicano una scelta evidenziata da \'|\' che significa "oppure".\n\n')

        -- groups --
        set_text('newDescription', 'Nuova descrizione:\n')
        set_text('noDescription', 'Nessuna descrizione disponibile.')
        set_text('description', 'Descrizione chat: ')
        set_text('newRules', 'Nuove regole:\n')
        set_text('noRules', 'Nessuna regola disponibile.')
        set_text('rules', 'Regole chat: ')
        set_text('sendNewGroupPic', 'Mandami la nuova foto del gruppo.')
        set_text('photoSaved', 'Foto salvata.')
        set_text('groupSettings', 'Impostazioni gruppo: ')
        set_text('supergroupSettings', 'Impostazioni supergruppo: ')
        set_text('noGroups', 'Nessun gruppo al momento.')
        set_text('errorFloodRange', 'Errore, il range è [3-200]')
        set_text('floodSet', 'Il flood è stato impostato a ')
        set_text('noOwnerCallAdmin', 'Nessun proprietario, chiedi ad un admin di settarne uno.')
        set_text('ownerIs', 'Il proprietario del gruppo è ')
        set_text('errorCreateLink', 'Errore creazione link d\'invito.\nNon sono la creatrice.')
        set_text('errorCreateSuperLink', 'Errore creazione link d\'invito.\nNon sono la creatrice.\n\nSe hai il link usa /setlink per impostarlo')
        set_text('createLinkInfo', 'Crea un link usando /newlink.')
        set_text('linkCreated', 'Nuovo link creato.')
        set_text('groupLink', 'Link\n')
        set_text('adminListStart', 'Admins:\n')
        set_text('alreadyMod', ' è già un mod.')
        set_text('promoteMod', ' è stato promosso a mod.')
        set_text('notMod', ' non è un mod.')
        set_text('demoteMod', ' è stato degradato da mod.')
        set_text('noGroupMods', 'Nessun moderatore in questo gruppo.')
        set_text('modListStart', 'Moderatori di ')
        set_text('muteUserAdd', ' aggiunto alla lista degli utenti silenziati.')
        set_text('muteUserRemove', ' rimosso dalla lista degli utenti silenziati.')
        set_text('modlistCleaned', 'Lista mod svuotata.')
        set_text('rulesCleaned', 'Regole svuotate.')
        set_text('descriptionCleaned', 'Descrizione svuotata.')
        set_text('mutelistCleaned', 'Lista muti svuotata.')

        -- info.lua --
        set_text('info', 'INFO')
        set_text('youAre', '\nTu sei')
        set_text('name', '\nNome: ')
        set_text('surname', '\nCognome: ')
        set_text('username', '\nUsername: ')
        set_text('youAreWriting', '\n\nStai scrivendo a')
        set_text('groupName', '\nNome gruppo: ')
        set_text('members', '\nMembri: ')
        set_text('supergroupName', '\nNome supergruppo: ')
        set_text('infoFor', 'Info per: ')
        set_text('users', '\nUtenti: ')
        set_text('admins', '\nAdmins: ')
        set_text('kickedUsers', '\nUtenti rimossi: ')
        set_text('userInfo', 'Info utente:')

        -- ingroup.lua --
        set_text('welcomeNewRealm', 'Benvenuto nel tuo nuovo reame.')
        set_text('realmIs', 'Questo è un reame.')
        set_text('realmAdded', 'Il reame è stato aggiunto.')
        set_text('realmAlreadyAdded', 'Il reame è già stato aggiunto.')
        set_text('realmRemoved', 'Il reame è stato rimosso.')
        set_text('realmNotAdded', 'Reame non aggiunto.')
        set_text('errorAlreadyRealm', 'Errore, è già un reame.')
        set_text('errorNotRealm', 'Errore, non è un reame.')
        set_text('promotedOwner', 'Sei stato promosso a proprietario.')
        set_text('groupIs', 'Questo è un gruppo.')
        set_text('groupAlreadyAdded', 'Il gruppo è già stato aggiunto.')
        set_text('groupAddedOwner', 'Il gruppo è stato aggiunto e tu promosso a proprietario.')
        set_text('groupRemoved', 'Il gruppo è stato rimosso.')
        set_text('groupNotAdded', 'Gruppo non aggiunto.')
        set_text('errorAlreadyGroup', 'Errore, è già un gruppo.')
        set_text('errorNotGroup', 'Errore, non è un gruppo.')
        set_text('noAutoDemote', 'Non puoi degradarti da solo.')

        -- inpm.lua --
        set_text('none', 'Nessuno')
        set_text('groupsJoin', 'Gruppi:\nUsa /join <group_id> per entrare\n\n')
        set_text('youGbanned', 'Sei bannato globalmente.')
        set_text('youBanned', 'Sei bannato.')
        set_text('chatNotFound', 'Chat non trovata.')
        set_text('privateGroup', 'Gruppo privato.')
        set_text('addedTo', 'Sei stato aggiunto a: ')
        set_text('supportAdded', 'Aggiunto membro di supporto ')
        set_text('adminAdded', 'Aggiunto admin ')
        set_text('toChat', ' a 👥 ')

        -- inrealm.lua --
        set_text('realm', 'Reame ')
        set_text('group', 'Gruppo ')
        set_text('created', ' creato.')
        set_text('chatTypeNotFound', 'Tipo chat non trovato.')
        set_text('usersIn', 'Utenti in ')
        set_text('alreadyAdmin', ' è già un admin.')
        set_text('promoteAdmin', ' è stato promosso ad admin.')
        set_text('notAdmin', ' non è un admin.')
        set_text('demoteAdmin', ' è stato degradato da admin.')
        set_text('groupListStart', 'Gruppi:\n')
        set_text('noRealms', 'Nessun reame al momento.')
        set_text('realmListStart', 'Reami:\n')
        set_text('inGroup', ' in questo gruppo')
        set_text('supportRemoved', ' è stato rimosso dal team di supporto.')
        set_text('supportAdded', ' è stato aggiunto al team di supporto.')
        set_text('logAlreadyYes', 'Gruppo di log già abilitato.')
        set_text('logYes', 'Gruppo di log abilitato.')
        set_text('logAlreadyNo', 'Gruppo di log già disabilitato.')
        set_text('logNo', 'Gruppo di log disabilitato.')
        set_text('descriptionSet', 'Descrizione settata per: ')
        set_text('errorGroup', 'Errore, gruppo ')
        set_text('errorRealm', 'Errore, reame ')
        set_text('notFound', ' non trovato')
        set_text('chat', 'Chat ')
        set_text('removed', ' rimossa')
        set_text('groupListCreated', 'Lista gruppi creata.')
        set_text('realmListCreated', 'Lista reami creata.')

        -- invite.lua --
        set_text('userBanned', 'L\'utente è bannato.')
        set_text('userGbanned', 'L\'utente è bannato globalmente.')
        set_text('privateGroup', 'Il gruppo è privato.')

        -- locks --
        set_text('nameLock', '\nBlocco nome: ')
        set_text('nameAlreadyLocked', 'Nome gruppo già bloccato.')
        set_text('nameLocked', 'Nome gruppo bloccato.')
        set_text('nameAlreadyUnlocked', 'Nome gruppo già sbloccato.')
        set_text('nameUnlocked', 'Nome gruppo sbloccato.')
        set_text('photoLock', '\nBlocco foto: ')
        set_text('photoAlreadyLocked', 'Foto gruppo già bloccata.')
        set_text('photoLocked', 'Foto gruppo bloccata.')
        set_text('photoAlreadyUnlocked', 'Foto gruppo già sbloccata.')
        set_text('photoUnlocked', 'Foto gruppo sbloccata.')
        set_text('membersLock', '\nBlocco membri: ')
        set_text('membersAlreadyLocked', 'Membri gruppo già bloccati.')
        set_text('membersLocked', 'Membri gruppo bloccati.')
        set_text('membersAlreadyUnlocked', 'Membri gruppo già sbloccati.')
        set_text('membersUnlocked', 'Membri gruppo sbloccati.')
        set_text('leaveLock', '\nBlocco abbandono: ')
        set_text('leaveAlreadyLocked', 'Uscita già punita col ban.')
        set_text('leaveLocked', 'Uscita punita col ban.')
        set_text('leaveAlreadyUnlocked', 'Uscita già consentita.')
        set_text('leaveUnlocked', 'Uscita consentita.')
        set_text('spamLock', '\nBlocco spam: ')
        set_text('spamAlreadyLocked', 'Spam già vietato.')
        set_text('spamLocked', 'Spam vietato.')
        set_text('spamAlreadyUnlocked', 'Spam già consentito.')
        set_text('spamUnlocked', 'Spam consentito.')
        set_text('floodSensibility', '\nSensibilità flood: ')
        set_text('floodUnlockOwners', 'Solo i proprietari possono sbloccare il flood.')
        set_text('floodLock', '\nBlocco flood: ')
        set_text('floodAlreadyLocked', 'Flood già bloccato.')
        set_text('floodLocked', 'Flood bloccato.')
        set_text('floodAlreadyUnlocked', 'Flood già sbloccato.')
        set_text('floodUnlocked', 'Flood sbloccato.')
        set_text('arabicLock', '\nBlocco arabo: ')
        set_text('arabicAlreadyLocked', 'Arabo già vietato.')
        set_text('arabicLocked', 'Arabo vietato.')
        set_text('arabicAlreadyUnlocked', 'Arabo già consentito.')
        set_text('arabicUnlocked', 'Arabo consentito.')
        set_text('botsLock', '\nBlocco bot: ')
        set_text('botsAlreadyLocked', 'Bots già vietati.')
        set_text('botsLocked', 'Bots vietati.')
        set_text('botsAlreadyUnlocked', 'Bots già consentiti.')
        set_text('botsUnlocked', 'Bots consentiti.')
        set_text('linksLock', '\nBlocco link: ')
        set_text('linksAlreadyLocked', 'Link già vietati.')
        set_text('linksLocked', 'Link vietati.')
        set_text('linksAlreadyUnlocked', 'Link già consentiti.')
        set_text('linksUnlocked', 'Link consentiti.')
        set_text('rtlLock', '\nBlocco RTL: ')
        set_text('rtlAlreadyLocked', 'Caratteri RTL già vietati.')
        set_text('rtlLocked', 'Caratteri RTL vietati.')
        set_text('rtlAlreadyUnlocked', 'Caratteri RTL già consentiti.')
        set_text('rtlUnlocked', 'Caratteri RTL consentiti.')
        set_text('tgserviceLock', '\nBlocco messaggi di servizio: ')
        set_text('tgserviceAlreadyLocked', 'Messaggi di servizio già bloccati.')
        set_text('tgserviceLocked', 'Messaggi di servizio bloccati.')
        set_text('tgserviceAlreadyUnlocked', 'Messaggi di servizio già sbloccati.')
        set_text('tgserviceUnlocked', 'Messaggi di servizio sbloccati.')
        set_text('stickersLock', '\nBlocco stickers: ')
        set_text('stickersAlreadyLocked', 'Stickers già vietati.')
        set_text('stickersLocked', 'Stickers vietati.')
        set_text('stickersAlreadyUnlocked', 'Stickers già consentiti.')
        set_text('stickersUnlocked', 'Stickers consentiti.')
        set_text('public', '\nPubblico: ')
        set_text('publicAlreadyYes', 'Gruppo già pubblico.')
        set_text('publicYes', 'Gruppo pubblico.')
        set_text('publicAlreadyNo', 'Gruppo già privato.')
        set_text('publicNo', 'Gruppo privato.')
        set_text('contactsAlreadyLocked', 'Condivisione contatti già vietata.')
        set_text('contactsLocked', 'Condivisione contatti vietata.')
        set_text('contactsAlreadyUnlocked', 'Condivisione contatti già consentita.')
        set_text('contactsUnlocked', 'Condivisione contatti consentita.')
        set_text('strictrules', '\nPugno di ferro: ')
        set_text('strictrulesAlreadyLocked', 'Pugno di ferro già attivato.')
        set_text('strictrulesLocked', 'Pugno di ferro attivato.')
        set_text('strictrulesAlreadyUnlocked', 'Pugno di ferro già disattivato.')
        set_text('strictrulesUnlocked', 'Pugno di ferro disattivato.')

        -- onservice.lua --
        set_text('notMyGroup', 'Questo non è un mio gruppo, addio.')

        -- owners.lua --
        set_text('notTheOwner', 'Non sei il proprietario di questo gruppo.')
        set_text('noAutoUnban', 'Non puoi unbannarti da solo.')

        -- plugins.lua --
        set_text('enabled', ' abilitato.')
        set_text('disabled', ' disabilitato.')
        set_text('alreadyEnabled', ' già abilitato.')
        set_text('alreadyDisabled', ' già disabilitato.')
        set_text('notExist', '  non esiste.')
        set_text('systemPlugin', 'Non è possibile disabilitare questo plugin in quanto è necessario per il corretto funzionamento del sistema.')
        set_text('disabledOnChat', ' disabilitato su questa chat.')
        set_text('noDisabledPlugin', 'Nessun plugin disabilitato su questa chat.')
        set_text('pluginNotDisabled', 'Questo plugin non è disabilitato su questa chat.')
        set_text('pluginEnabledAgain', ' nuovamente abilitato.')
        set_text('pluginsReloaded', 'Plugins ricaricati.')

        -- pokedex.lua --
        set_text('noPoke', 'Nessun pokémon trovato.')
        set_text('pokeName', 'Nome: ')
        set_text('pokeWeight', 'Peso: ')
        set_text('pokeHeight', 'Altezza: ')

        -- ruleta.lua --
        set_text('alreadySigned', 'Sei già registrato, usa /ruleta per morire.')
        set_text('signed', ' Sei stato registrato, have a nice death.')
        set_text('requireSignup', 'Prima di morire devi registrarti.')
        set_text('errorCapsRange', 'Errore, il range è [1-X].')
        set_text('errorCylinderRange', 'Errore, il range è [5-10].')

        -- set.lua --
        set_text('saved', ' salvato.')

        -- spam.lua --
        set_text('msgSet', 'Messaggio impostato.')
        set_text('msgsToSend', 'Messaggi da mandare: ')
        set_text('timeBetweenMsgs', 'Tempo tra ogni messaggio: X secondi.')
        set_text('msgNotSet', 'Non hai impostato il messaggio, usa /setspam.')

        -- stats.lua --
        set_text('usersInChat', 'Utenti in questa chat\n')
        set_text('groups', '\nGruppi: ')

        -- strings.lua --
        set_text('langUpdate', 'ℹ️ Stringhe aggiornate.')

        -- supergroup.lua --
        set_text('makeBotAdmin', 'Promuovimi prima amministratrice!')
        set_text('groupIs', 'Questo è un gruppo.')
        set_text('supergroupAlreadyAdded', 'Il supergruppo è già stato aggiunto.')
        set_text('errorAlreadySupergroup', 'Errore, è già un supergruppo.')
        set_text('supergroupAdded', 'Il supergruppo è stato aggiunto.')
        set_text('supergroupRemoved', 'Il supergruppo è stato rimosso.')
        set_text('supergroupNotAdded', 'Supergruppo non aggiunto.')
        set_text('membersOf', 'Membri di ')
        set_text('membersKickedFrom', 'Membri rimossi da ')
        set_text('cantKickOtherAdmin', 'Non puoi rimuovere altri amministratori.')
        set_text('promoteSupergroupMod', ' è stato promosso ad amministratore (telegram).')
        set_text('demoteSupergroupMod', ' è stato degradato da amministratore (telegram).')
        set_text('alreadySupergroupMod', ' è già un amministratore (telegram).')
        set_text('notSupergroupMod', ' non è un amministratore (telegram).')
        set_text('cantDemoteOtherAdmin', 'Non puoi degradare altri amministratori.')
        set_text('leftKickme', 'Uscito tramite /kickme.')
        set_text('setOwner', ' ora è l\'owner.')
        set_text('inThisSupergroup', ' in questo supergruppo.')
        set_text('sendLink', 'Mandami il link del gruppo.')
        set_text('linkSaved', 'Nuovo link impostato.')
        set_text('supergroupUsernameChanged', 'Username supergruppo cambiato.')
        set_text('errorChangeUsername', 'Errore nell\'impostare l\'username.\nPotrebbe già essere in uso.\n\nPuoi usare lettere numeri e l\'underscore.\nLunghezza minima 5 caratteri.')
        set_text('usernameCleaned', 'Username gruppo pulito.')
        set_text('errorCleanedUsername', 'Errore nel tentativo di pulire l\'username.')

        -- unset.lua --
        set_text('deleted', ' eliminato.')

        -- warn.lua --
        set_text('errorWarnRange', 'Errore, il range è [1-10].')
        set_text('warnSet', 'Il warn è stato impostato a ')
        set_text('noWarnSet', 'Il warn non è ancora stato impostato.')
        set_text('cantWarnHigher', 'Non puoi avvertire un mod/owner/admin/sudo!')
        set_text('warned', 'Sei stato avvertito X volte, datti una regolata!')
        set_text('zeroWarnings', 'I tuoi avvertimenti sono stati azzerati.')
        set_text('yourWarnings', 'Sei a quota X avvertimenti su un massimo di Y.')

        -- welcome.lua --
        set_text('newWelcome', 'Nuovo messaggio di benvenuto:\n')
        set_text('newWelcomeNumber', 'Il benvenuto sarà mandato ogni X membri.')
        set_text('noSetValue', 'Nessun valore impostato.')

        -- whitelist.lua --
        set_text('userBot', 'Utente/Bot ')
        set_text('whitelistRemoved', ' rimosso dalla whitelist.')
        set_text('whitelistAdded', ' aggiunto alla whitelist.')
        set_text('whitelistCleaned', 'Whitelist svuotata.')

        --------------
        ---- Usages --
        --------------
        ---- bot.lua --
        -- set_text('bot:0', 2)
        -- set_text('bot:1', 'BOT')
        -- set_text('bot:2', '(#bot|sasha) on|off: abilita|disabilita il bot sul gruppo corrente.')
        --
        ---- commands.lua --
        -- set_text('commands:0', 3)
        -- set_text('commands:1', 'COMMANDS')
        -- set_text('commands:2', '#(commands|help all)|sasha aiuto tutto: mostra la descrizione di ogni plugin.')
        -- set_text('commands:3', '(#(commands|help)|sasha aiuto) <plugin>: descrizione di <plugin>.')
        --
        ---- giverank.lua --
        -- set_text('giverank:0', 7)
        -- set_text('giverank:1', 'GIVE RANK')
        -- set_text('giverank:2', '(#(rank|promote)|[sasha] promuovi) admin <id>|<username>|<reply>: promuovi ad amministratore.')
        -- set_text('giverank:3', '(#(rank|promote)|[sasha] promuovi) mod <id>|<username>|<reply>: promuovi a moderatore.')
        -- set_text('giverank:4', '#rank guest <id>|<username>|<reply>: togli ogni carica all\'utente.')
        -- set_text('giverank:5', '#admin[s][list]|[sasha] lista admin: lista amministratori del gruppo.')
        -- set_text('giverank:6', '#mod[s][list]|[sasha] lista mod: lista moderatori del gruppo.')
        -- set_text('giverank:7', '#member[s][list]|[sasha] lista membri: lista membri del gruppo.')
        --
        ---- id.lua --
        -- set_text('id:0', 7)
        -- set_text('id:1', 'ID')
        -- set_text('id:2', '#id: mostra il tuo ID e l\'ID del gruppo se ti trovi in una chat.')
        -- set_text('id:3', '#ids chat: mostra gli ID dei membri del gruppo.')
        -- set_text('id:4', '#ids channel: mostra gli ID dei membri del supergruppo.')
        -- set_text('id:5', '#id <username>: mostra l\'ID dell\'utente in questa chat.')
        -- set_text('id:6', '#whois <id_utente>|<username>: mostra lo username.')
        -- set_text('id:7', '#whois (risposta): mostra l\'ID.')
        --
        ---- moderation.lua --
        -- set_text('moderation:0', 14)
        -- set_text('moderation:1', 'MODERATION')
        -- set_text('moderation:2', '(#kickme|[sasha] uccidimi): fatti rimuovere.')
        -- set_text('moderation:3', '(#mute|[sasha] togli voce) <id>|<username>|<reply>: silenzia un utente nel supergruppo, ogni suo messaggio verrà cancellato.')
        -- set_text('moderation:4', '(#unmute|[sasha] dai voce) <id>|<username>|<reply>: desilenzia un utente nel supergruppo.')
        -- set_text('moderation:5', '(#mutelist|[sasha] lista muti): manda la lista degli utenti muti.')
        -- set_text('moderation:6', '#kick|[sasha] uccidi|spara <id>|<username>|<reply>: rimuovi un utente dal gruppo/supergruppo.')
        -- set_text('moderation:7', '(#kicknouser|[sasha] uccidi nouser|spara nouser): rimuovi tutti gli utenti senza username dal gruppo/supergruppo.')
        -- set_text('moderation:8', '#ban|[sasha] banna|[sasha] decompila|esplodi|kaboom <id>|<username>|<reply>: banna un utente dal gruppo/supergruppo.')
        -- set_text('moderation:9', '(#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>: unbanna un utente dal gruppo/supergruppo.')
        -- set_text('moderation:10', '(#banlist|[sasha] lista ban): manda la lista degli utenti bannati.')
        -- set_text('moderation:11', '(#gban|[sasha] superbanna) <id>|<username>|<reply>: banna globalmente un utente da ogni gruppo/supergruppo.')
        -- set_text('moderation:12', '(#ungban|[sasha] supersbanna) <id>|<username>|<reply>: unbanna globalmente un utente da ogni gruppo/supergruppo.')
        -- set_text('moderation:13', '(#gbanlist|[sasha] lista superban): manda la lista degli utenti bannati globalmente.')
        -- set_text('moderation:14', '(#add|#invite|[sasha] invita|[sasha] resuscita) <id>|<username>|<reply>: aggiungi un utente al gruppo/supergruppo.')
        --
        ---- settings.lua --
        -- set_text('settings:0', 23)
        -- set_text('settings:1', 'SETTINGS')
        -- set_text('settings:2', '#settings stickers enable|disable: quando abilitato, ogni sticker verrà rimosso.')
        -- set_text('settings:3', '#settings links enable|disable: quando abilitato, ogni link verrà rimosso.')
        -- set_text('settings:4', '#settings arabic enable|disable: quando abilitato, ogni messaggio contenente caratteri arabi e persiani verrà rimosso.')
        -- set_text('settings:5', '#settings bots enable|disable: quando abilitato, ogni ogni bot aggiunto verrà rimosso.')
        -- set_text('settings:6', '#settings gifs enable|disable: quando abilitato, ogni gif verrà rimossa.')
        -- set_text('settings:7', '#settings photos enable|disable: quando abilitato, ogni immagine verrà rimossa.')
        -- set_text('settings:8', '#settings audios enable|disable: quando abilitato, ogni vocale verrà rimosso.')
        -- set_text('settings:9', '#settings kickme enable|disable: quando abilitato, gli utenti possono kickarsi autonomamente.')
        -- set_text('settings:10', '#settings spam enable|disable: quando abilitato, ogni link spam verrà rimosso.')
        -- set_text('settings:11', '#settings setphoto enable|disable: quando abilitato, se un utente cambia icona del gruppo, il bot ripristinerà quella salvata.')
        -- set_text('settings:12', '#settings setname enable|disable: quando abilitato, se un utente cambia il nome del gruppo, il bot ripristinerà il nome salvato.')
        -- set_text('settings:13', '#settings lockmembers enable|disable: quando abilitato, il bot rimuoverà ogni utente che etrerà nel gruppo.')
        -- set_text('settings:14', '#settings floodtime <secondi>: imposta l\'intervallo di monitoraggio del flood.')
        -- set_text('settings:15', '#settings maxflood <messaggi>: imposta il numero di messaggi inviati nel floodtime affinchè vengano considerati flood.')
        -- set_text('settings:16', '#setname <name>: cambia il nome della chat.')
        -- set_text('settings:17', '(#setdescription|sasha imposta descrizione) <text>: cambia la descrizione del supergruppo.')
        -- set_text('settings:18', '#setphoto <poi invia la foto>: cambia la foto della chat.')
        -- set_text('settings:19', '#lang <language (en, es...)>: cambia l\'idioma del bot.')
        -- set_text('settings:20', '(#newlink|sasha crea link) <link>: crea il link del gruppo.')
        -- set_text('settings:21', '(#setlink|sasha imposta link) <link>: salva il link del gruppo.')
        -- set_text('settings:22', '[#]link: mostra il link del gruppo.')
        -- set_text('settings:23', '#rem <reply>: rimuove un messaggio.')
        --
        ---- plugins.lua --
        -- set_text('plugins:0', 5)
        -- set_text('plugins:1', 'PLUGINS')
        -- set_text('plugins:2', '(#plugins|[sasha] lista plugins): mostra una lista di tutti i plugin.')
        -- set_text('plugins:3', '(#[plugin[s]] enable|disable)|([sasha] abilita|attiva|disabilita|disattiva) <plugin>: abilita|disabilita il plugin specificato.')
        -- set_text('plugins:4', '(#[plugin[s]] enable|disable)|([sasha] abilita|attiva|disabilita|disattiva) <plugin> chat: abilita|disabilita il plugin specificato solo sulla chat corrente.')
        -- set_text('plugins:5', '(#[plugin[s]] reload)|([sasha] ricarica): ricarica tutti i plugin.')
        --
        ---- version.lua --
        -- set_text('version:0', 2)
        -- set_text('version:1', 'VERSION')
        -- set_text('version:2', '#version: mostra la versione del bot.')
        --
        ---- rules.lua --
        -- set_text('rules:0', 4)
        -- set_text('rules:1', 'RULES')
        -- set_text('rules:2', '#rules|sasha regole: mostra le regole della chat.')
        -- set_text('rules:3', '(#setrules|sasha imposta regole) <text>: imposta le regole della chat.')
        -- set_text('rules:4', '#remrules|sasha rimuovi regole: rimuove le regole della chat.')
        --
        ---- get.lua --
        -- set_text('get:0', 3)
        -- set_text('get:1', 'GET')
        -- set_text('get:2', '(#get|#getlist|sasha lista): mostra la lista delle variabili settate.')
        -- set_text('get:3', '[#get] <var_name>: manda il testo associato a <var_name>.')
        --
        ---- set.lua --
        -- set_text('set:0', 2)
        -- set_text('set:1', 'SET')
        -- set_text('set:2', '(#set|[sasha] setta) <var_name> <text>: setta <text> in risposta a <var_name>.')
        --
        ---- unset.lua --
        -- set_text('unset:0', 2)
        -- set_text('unset:1', 'UNSET')
        -- set_text('unset:2', '(#unset|[sasha] unsetta) <var_name>: elimina <var_name>.')
        --
        ---- tagall.lua --
        -- set_text('tagall:0', 2)
        -- set_text('tagall:1', 'TAGALL')
        -- set_text('tagall:2', '(#tagall|sasha tagga tutti) <text>: tagga tutti gli utenti con username del gruppo/supergruppo.')
        --
        ---- shout.lua --
        -- set_text('shout:0', 2)
        -- set_text('shout:1', 'SHOUT')
        -- set_text('shout:2', '([#]shout|[sasha] grida|[sasha] urla) <text>: "urla" <text>.')
        --
        ---- ruleta.lua --
        -- set_text('ruleta:0', 3)
        -- set_text('ruleta:1', 'RULETA')
        -- set_text('ruleta:2', '[#]ruleta: estrae un numero casuale tra 0 e 10, se è uguale rimuove l\'utente dal gruppo/supergruppo.')
        -- set_text('ruleta:3', '#kick|[sasha] uccidi|spara random: sceglie un utente a caso e lo rimuove dal gruppo supergruppo.')
        --
        ---- feedback.lua --
        -- set_text('feedback:0', 2)
        -- set_text('feedback:1', 'FEEDBACK')
        -- set_text('feedback:2', '[#]feedback: invia un feedback al creatore del bot.')
        --
        ---- echo.lua --
        -- set_text('echo:0', 2)
        -- set_text('echo:1', 'ECHO')
        -- set_text('echo:2', '(#echo|sasha ripeti) <text>: ripete <text>.')
        --
        ---- dogify.lua --
        -- set_text('dogify:0', 2)
        -- set_text('dogify:1', 'DOGIFY')
        -- set_text('dogify:2', '(#dogify|[sasha] doge) <your/words/with/slashes>: crea un\'immagine col doge e le parole specificate.')
        --
        ---- words.lua --
        -- set_text('words:0', 2)
        -- set_text('words:1', 'WORDS')
        -- set_text('words:2', 'gangbang|maometto|maometo|cancaroman|mohammed|nazi|hitler')
        --
        ---- tex.lua --
        -- set_text('tex:0', 2)
        -- set_text('tex:1', 'TEX')
        -- set_text('tex:2', '(#tex|[sasha] equazione) <equation>: converte <equation> in immagine.')
        --
        ---- qr.lua --
        -- set_text('qr:0', 2)
        -- set_text('qr:1', 'QR')
        -- set_text('qr:2', '[#]|[sasha] qr ["<background_color>" "<data_color>"] <text>: crea il QR Code di <text> e se specificato lo colora, i colori possono essere specificati come segue:\nTesto => red|green|blue|purple|black|white|gray.\nNotazione Esadecimale => (\"a56729\" è marrone).\nNotazione Decimale => (\"255-192-203\" è rosa).')
        --
        ---- apod.lua --
        -- set_text('apod:0', 4)
        -- set_text('apod:1', 'APOD')
        -- set_text('apod:2', '#(apod|astro) [<date>]: manda l\'APOD.')
        -- set_text('apod:3', '#(apod|astro)hd [<date>]: manda l\'APOD in HD.')
        -- set_text('apod:4', '#(apod|astro)text [<date>]: manda la spiegazione dell\'APOD.')
        --
        ---- google.lua --
        -- set_text('google:0', 2)
        -- set_text('google:1', 'GOOGLE')
        -- set_text('google:2', '(#google|[sasha] googla) <terms>: manda i primi risultati di google.')
        --
        ---- pokedex.lua --
        -- set_text('pokedex:0', 2)
        -- set_text('pokedex:1', 'POKÉDEX')
        -- set_text('pokedex:2', '#(pokémon|pokédex) <name>|<id>: manda le informazioni del pokémon.')
        --
        ---- urbandictionary.lua --
        -- set_text('urbandictionary:0', 2)
        -- set_text('urbandictionary:1', 'URBAN DICTIONARY')
        -- set_text('urbandictionary:2', '(#urbandictionary|([#]|[sasha] urban)|([#]|[sasha] ud)) <text>: mostra la definizione dell\'urban dictionary di <text>.')
        --
        ---- webshot.lua --
        -- set_text('webshot:0', 2)
        -- set_text('webshot:1', 'WEBSHOT')
        -- set_text('webshot:2', '[#]|[sasha] webshot <link>: manda lo screenshot di un sito.')
        --
        ---- wiki.lua --
        -- set_text('wiki:0', 3)
        -- set_text('wiki:1', 'WIKI')
        -- set_text('wiki:2', '[#]|[sasha] wiki[lang] <text>: manda un estratto da [lang] Wikipedia.')
        -- set_text('wiki:3', '[#]|[sasha] wiki[lang] search <text>: manda gli articoli di [lang] Wikipedia.')
        return lang_text('langUpdate')
    else
        return lang_text('require_sudo')
    end
end

return {
    description = "STRINGS",
    usage =
    {
        "SUDO",
        "#updatestrings|#installstrings|[sasha] installa|aggiorna stringhe: Sasha aggiorna le stringhe di testo.",
    },
    patterns =
    {
        '^[#!/]([Ii][Nn][Ss][Tt][Aa][Ll][Ll][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        '^[#!/]([Uu][Pp][Dd][Aa][Tt][Ee][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        -- installstrings
        '^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ss][Tt][Aa][Ll][Ll][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee])$',
        '^([Ii][Nn][Ss][Tt][Aa][Ll][Ll][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee])$',
        -- updatestrings
        '^([Ss][Aa][Ss][Hh][Aa] [Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee])$',
        '^([Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee])$',
    },
    run = run,
    min_rank = 5
}
