--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------

local LANG = 'it:'

local function run(msg, matches)
    if is_sudo(msg) then
        -------------
        -- Plugins --
        -------------

        redis:set('lang', LANG)

        -- global --
        set_text(LANG .. 'require_sudo', '🚫 Questo comando richiede i privilegi di sudo.')
        set_text(LANG .. 'require_admin', '🚫 Questo comando richiede privilegi da admin o superiori.')
        set_text(LANG .. 'require_owner', '🚫 Questo comando richiede privilegi da owner o superiori.')
        set_text(LANG .. 'require_mod', '🚫 Questo comando richiede privilegi da moderatore o superiori.')
        set_text(LANG .. 'errorTryAgain', 'Errore, prova di nuovo.')
        set_text(LANG .. 'opsError', 'Ops, errore.')
        set_text(LANG .. 'useYourGroups', 'Usalo nei tuoi gruppi!')
        set_text(LANG .. 'cantKickHigher', 'Non puoi rimuovere un mod/owner/admin/sudo!')
        set_text(LANG .. 'user', 'Utente ')
        set_text(LANG .. 'kicked', ' rimosso.')
        set_text(LANG .. 'banned', ' bannato.')
        set_text(LANG .. 'unbanned', ' unbannato.')
        set_text(LANG .. 'gbanned', ' bannato globalmente.')
        set_text(LANG .. 'ungbanned', ' unbannato globalmente.')

        -- seedbot.lua --
        set_text(LANG .. 'sender', 'Mittente: ')
        set_text(LANG .. 'receiver', 'Ricevente: ')
        set_text(LANG .. 'msgText', 'Testo del messaggio: ')

        -- utils.lua --
        set_text(LANG .. 'errorImageDownload', 'Errore nel download dell\'immagine.')
        set_text(LANG .. 'banListStart', 'Lista ban:\n\n')
        set_text(LANG .. 'gbanListStart', 'Lista ban globali:\n\n')
        set_text(LANG .. 'mutedUsersStart', 'Utenti muti di:')
        set_text(LANG .. 'mutedTypesStart', 'Muti di:')
        set_text(LANG .. 'mute', 'Muto ')
        set_text(LANG .. 'alreadyEnabled', ' già attivato.')
        set_text(LANG .. 'enabled', ' attivato.')
        set_text(LANG .. 'alreadyDisabled', ' già disattivato.')
        set_text(LANG .. 'disabled', ' disattivato')
        set_text(LANG .. 'noAutoKick', 'Non puoi rimuoverti da solo.')
        set_text(LANG .. 'noAutoBan', 'Non puoi bannarti da solo.')

        -- admin.lua --
        set_text(LANG .. 'sendNewPic', 'Mandami la nuova foto.')
        set_text(LANG .. 'botPicChanged', 'Foto cambiata!')
        set_text(LANG .. 'logSet', 'Il log è stato aggiunto.')
        set_text(LANG .. 'logUnset', 'Il log è stato rimosso.')
        set_text(LANG .. 'markRead', 'Segna come già letto')
        set_text(LANG .. 'pmSent', 'Messaggio mandato')
        set_text(LANG .. 'cantBlockAdmin', 'Non puoi bloccare un admin.')
        set_text(LANG .. 'userBlocked', 'Utente bloccato.')
        set_text(LANG .. 'userUnblocked', 'Utente sbloccato.')
        set_text(LANG .. 'contactListSent', 'Ti ho mandato in privato la lista dei contatti nel formato da te richiesto.')
        set_text(LANG .. 'removedFromContacts', ' rimosso dai contatti.')
        set_text(LANG .. 'addedToContacts', ' aggiunto ai contatti.')
        set_text(LANG .. 'contactMissing', 'Non ho il tuo numero di telefono!')
        set_text(LANG .. 'chatListSent', 'Ti ho mandato in privato la lista delle chat nel formato da te richiesto.')
        set_text(LANG .. 'gbansSync', 'Lista ban globali sincronizzata.')
        set_text(LANG .. 'longidUpdate', 'Aggiorna long_ID.')
        set_text(LANG .. 'alreadyLog', 'Già un gruppo di log.')
        set_text(LANG .. 'notLog', 'Non un gruppo di log.')
        set_text(LANG .. 'backupDone', 'Backup eseguito, ti invio il log in privato.')

        -- anti_spam.lua --
        set_text(LANG .. 'blockedForSpam', ' bloccato (SPAM).')
        set_text(LANG .. 'floodNotAdmitted', 'Il flood non è ammesso.\n')
        set_text(LANG .. 'statusRemoved', 'Utente rimosso.')
        set_text(LANG .. 'gbannedFrom', ' bannato globalmente da ')

        -- arabic_lock.lua --
        set_text(LANG .. 'arabicNotAllowed', 'L\'arabo/Il persiano non è ammesso.\n')
        set_text(LANG .. 'statusRemovedMsgDeleted', 'Utente rimosso/messaggio eliminato.')

        -- banhammer.lua --
        set_text(LANG .. 'noUsernameFound', 'Non trovo nessun utente con quell\'username.')

        -- bot.lua --
        set_text(LANG .. 'botOn', 'Sono tornata. 😏')
        set_text(LANG .. 'botOff', 'Nulla da fare qui. 🚀')

        -- feedback.lua --
        set_text(LANG .. 'feedStart', '@EricSolinas hai ricevuto un feedback: #newfeedback\n\nMittente')
        set_text(LANG .. 'feedName', '\nNome: ')
        set_text(LANG .. 'feedSurname', '\nCognome: ')
        set_text(LANG .. 'feedUsername', '\nUsername: @')
        set_text(LANG .. 'feedSent', 'Feedback inviato!')

        -- filemanager.lua --
        set_text(LANG .. 'backHomeFolder', 'Sei tornato alla cartella base: ')
        set_text(LANG .. 'youAreHere', 'Sei qui: ')
        set_text(LANG .. 'folderCreated', 'Cartella \'X\' creata.')
        set_text(LANG .. 'folderDeleted', 'Cartella \'X\' eliminata.')
        set_text(LANG .. 'fileCreatedWithContent', ' creato con \'X\' come contenuto.')
        set_text(LANG .. 'copiedTo', ' copiato in ')
        set_text(LANG .. 'movedTo', ' spostato in ')
        set_text(LANG .. 'sendingYou', 'Ti sto inviando ')
        set_text(LANG .. 'useQuoteOnFile', 'Usa \'rispondi\' sul file che vuoi che scarichi.')
        set_text(LANG .. 'needMedia', 'Mi serve un file.')
        set_text(LANG .. 'fileDownloadedTo', 'File scaricato in: ')
        set_text(LANG .. 'errorDownloading', 'Errore durante il download: ')

        -- flame.lua --
        set_text(LANG .. 'cantFlameHigher', 'Non puoi flammare un mod/owner/admin/sudo/!')
        set_text(LANG .. 'noAutoFlame', 'Non posso flammarmi da sola trisomico del cazzo!')
        set_text(LANG .. 'hereIAm', 'Eccomi qua!')
        set_text(LANG .. 'stopFlame', 'Si si mi fermo però porca madonna.')
        set_text(LANG .. 'flaming', 'Sto flammando: ')
        set_text(LANG .. 'errorParameter', 'Errore variabile redis mancante.')

        -- help.lua --
        set_text(LANG .. 'require_higher', '🚫 Questo plugin richiede privilegi superiori a quelli che possiedi.\n')
        set_text(LANG .. 'pluginListStart', 'ℹ️Lista plugin: \n\n')
        set_text(LANG .. 'helpInfo', 'ℹ️Scrivi "!help <plugin_name>|<plugin_number>" per maggiori informazioni su quel plugin.\nℹ️O "!helpall" per mostrare tutte le informazioni.')
        set_text(LANG .. 'errorNoPlugin', 'Questo plugin non esiste o non ha una descrizione.')
        set_text(LANG .. 'doYourBusiness', 'Ma una sportina di cazzi tuoi no?')
        set_text(LANG .. 'helpIntro', 'Ogni \'#\' può essere sostituito con i simboli \'/\' o \'!\'.\nTutti i comandi sono Case Insensitive.\nLe parentesi quadre significano opzionale.\nLe parentesi tonde indicano una scelta evidenziata da \'|\' che significa "oppure".\n\n')
        set_text(LANG .. 'youTried', 'Ci hai provato, non avrai un help più dettagliato di quello che ti spetta, pezzente.')

        -- groups --
        set_text(LANG .. 'newDescription', 'Nuova descrizione:\n')
        set_text(LANG .. 'noDescription', 'Nessuna descrizione disponibile.')
        set_text(LANG .. 'description', 'Descrizione chat: ')
        set_text(LANG .. 'newRules', 'Nuove regole:\n')
        set_text(LANG .. 'noRules', 'Nessuna regola disponibile.')
        set_text(LANG .. 'rules', 'Regole chat: ')
        set_text(LANG .. 'sendNewGroupPic', 'Mandami la nuova foto del gruppo.')
        set_text(LANG .. 'photoSaved', 'Foto salvata.')
        set_text(LANG .. 'groupSettings', 'Impostazioni gruppo: ')
        set_text(LANG .. 'supergroupSettings', 'Impostazioni supergruppo: ')
        set_text(LANG .. 'noGroups', 'Nessun gruppo al momento.')
        set_text(LANG .. 'errorFloodRange', 'Errore, il range è [3-200]')
        set_text(LANG .. 'floodSet', 'Il flood è stato impostato a ')
        set_text(LANG .. 'noOwnerCallAdmin', 'Nessun proprietario, chiedi ad un admin di settarne uno.')
        set_text(LANG .. 'ownerIs', 'Il proprietario del gruppo è ')
        set_text(LANG .. 'errorCreateLink', 'Errore creazione link d\'invito.\nNon sono la creatrice.')
        set_text(LANG .. 'errorCreateSuperLink', 'Errore creazione link d\'invito.\nNon sono la creatrice.\n\nSe hai il link usa /setlink per impostarlo')
        set_text(LANG .. 'createLinkInfo', 'Crea un link usando /newlink.')
        set_text(LANG .. 'linkCreated', 'Nuovo link creato.')
        set_text(LANG .. 'groupLink', 'Link\n')
        set_text(LANG .. 'adminListStart', 'Admins:\n')
        set_text(LANG .. 'alreadyMod', ' è già un mod.')
        set_text(LANG .. 'promoteMod', ' è stato promosso a mod.')
        set_text(LANG .. 'notMod', ' non è un mod.')
        set_text(LANG .. 'demoteMod', ' è stato degradato da mod.')
        set_text(LANG .. 'noGroupMods', 'Nessun moderatore in questo gruppo.')
        set_text(LANG .. 'modListStart', 'Moderatori di ')
        set_text(LANG .. 'muteUserAdd', ' aggiunto alla lista degli utenti silenziati.')
        set_text(LANG .. 'muteUserRemove', ' rimosso dalla lista degli utenti silenziati.')
        set_text(LANG .. 'modlistCleaned', 'Lista mod svuotata.')
        set_text(LANG .. 'rulesCleaned', 'Regole svuotate.')
        set_text(LANG .. 'descriptionCleaned', 'Descrizione svuotata.')
        set_text(LANG .. 'mutelistCleaned', 'Lista muti svuotata.')

        -- info.lua --
        set_text(LANG .. 'info', 'INFO')
        set_text(LANG .. 'youAre', '\nTu sei')
        set_text(LANG .. 'name', '\nNome: ')
        set_text(LANG .. 'surname', '\nCognome: ')
        set_text(LANG .. 'username', '\nUsername: ')
        set_text(LANG .. 'phone', '\nTelefono: ')
        set_text(LANG .. 'date', '\nData: ')
        set_text(LANG .. 'totalMessages', '\nMessaggi totali: ')
        set_text(LANG .. 'youAreWriting', '\n\nStai scrivendo a')
        set_text(LANG .. 'groupName', '\nNome gruppo: ')
        set_text(LANG .. 'members', '\nMembri: ')
        set_text(LANG .. 'supergroupName', '\nNome supergruppo: ')
        set_text(LANG .. 'infoFor', 'Info per: ')
        set_text(LANG .. 'users', '\nUtenti: ')
        set_text(LANG .. 'admins', '\nAdmins: ')
        set_text(LANG .. 'kickedUsers', '\nUtenti rimossi: ')
        set_text(LANG .. 'userInfo', 'Info utente:')

        -- ingroup.lua --
        set_text(LANG .. 'welcomeNewRealm', 'Benvenuto nel tuo nuovo regno.')
        set_text(LANG .. 'realmIs', 'Questo è un regno.')
        set_text(LANG .. 'realmAdded', 'Il regno è stato aggiunto.')
        set_text(LANG .. 'realmAlreadyAdded', 'Il regno è già stato aggiunto.')
        set_text(LANG .. 'realmRemoved', 'Il regno è stato rimosso.')
        set_text(LANG .. 'realmNotAdded', 'Regno non aggiunto.')
        set_text(LANG .. 'errorAlreadyRealm', 'Errore, è già un regno.')
        set_text(LANG .. 'errorNotRealm', 'Errore, non è un regno.')
        set_text(LANG .. 'promotedOwner', 'Sei stato promosso a proprietario.')
        set_text(LANG .. 'groupIs', 'Questo è un gruppo.')
        set_text(LANG .. 'groupAlreadyAdded', 'Il gruppo è già stato aggiunto.')
        set_text(LANG .. 'groupAddedOwner', 'Il gruppo è stato aggiunto e tu promosso a proprietario.')
        set_text(LANG .. 'groupRemoved', 'Il gruppo è stato rimosso.')
        set_text(LANG .. 'groupNotAdded', 'Gruppo non aggiunto.')
        set_text(LANG .. 'errorAlreadyGroup', 'Errore, è già un gruppo.')
        set_text(LANG .. 'errorNotGroup', 'Errore, non è un gruppo.')
        set_text(LANG .. 'noAutoDemote', 'Non puoi degradarti da solo.')

        -- inpm.lua --
        set_text(LANG .. 'none', 'Nessuno')
        set_text(LANG .. 'groupsJoin', 'Gruppi:\nUsa /join <group_id> per entrare\n\n')
        set_text(LANG .. 'realmsJoin', 'Reami:\nUsa /join <realm_id> per entrare\n\n')
        set_text(LANG .. 'youGbanned', 'Sei bannato globalmente.')
        set_text(LANG .. 'youBanned', 'Sei bannato.')
        set_text(LANG .. 'chatNotFound', 'Chat non trovata.')
        set_text(LANG .. 'privateGroup', 'Gruppo privato.')
        set_text(LANG .. 'addedTo', 'Sei stato aggiunto a: ')
        set_text(LANG .. 'supportAdded', 'Aggiunto membro di supporto ')
        set_text(LANG .. 'adminAdded', 'Aggiunto admin ')
        set_text(LANG .. 'toChat', ' a 👥 ')
        set_text(LANG .. 'aliasSaved', 'Alias salvato.')
        set_text(LANG .. 'aliasDeleted', 'Alias eliminato.')
        set_text(LANG .. 'noAliasFound', 'Nessun gruppo trovato con quell\'alias.')

        -- inrealm.lua --
        set_text(LANG .. 'realm', 'Regno ')
        set_text(LANG .. 'group', 'Gruppo ')
        set_text(LANG .. 'created', ' creato.')
        set_text(LANG .. 'chatTypeNotFound', 'Tipo chat non trovato.')
        set_text(LANG .. 'usersIn', 'Utenti in ')
        set_text(LANG .. 'alreadyAdmin', ' è già un admin.')
        set_text(LANG .. 'promoteAdmin', ' è stato promosso ad admin.')
        set_text(LANG .. 'notAdmin', ' non è un admin.')
        set_text(LANG .. 'demoteAdmin', ' è stato degradato da admin.')
        set_text(LANG .. 'groupListStart', 'Gruppi:\n')
        set_text(LANG .. 'noRealms', 'Nessun regno al momento.')
        set_text(LANG .. 'realmListStart', 'Reami:\n')
        set_text(LANG .. 'inGroup', ' in questo gruppo')
        set_text(LANG .. 'supportRemoved', ' è stato rimosso dal team di supporto.')
        set_text(LANG .. 'supportAdded', ' è stato aggiunto al team di supporto.')
        set_text(LANG .. 'logAlreadyYes', 'Gruppo di log già abilitato.')
        set_text(LANG .. 'logYes', 'Gruppo di log abilitato.')
        set_text(LANG .. 'logAlreadyNo', 'Gruppo di log già disabilitato.')
        set_text(LANG .. 'logNo', 'Gruppo di log disabilitato.')
        set_text(LANG .. 'descriptionSet', 'Descrizione settata per: ')
        set_text(LANG .. 'errorGroup', 'Errore, gruppo ')
        set_text(LANG .. 'errorRealm', 'Errore, regno ')
        set_text(LANG .. 'notFound', ' non trovato')
        set_text(LANG .. 'chat', 'Chat ')
        set_text(LANG .. 'removed', ' rimossa')
        set_text(LANG .. 'groupListCreated', 'Lista gruppi creata.')
        set_text(LANG .. 'realmListCreated', 'Lista reami creata.')

        -- invite.lua --
        set_text(LANG .. 'userBanned', 'L\'utente è bannato.')
        set_text(LANG .. 'userGbanned', 'L\'utente è bannato globalmente.')
        set_text(LANG .. 'privateGroup', 'Il gruppo è privato.')

        -- locks --
        set_text(LANG .. 'nameLock', '\nBlocco nome: ')
        set_text(LANG .. 'nameAlreadyLocked', 'Nome gruppo già bloccato.')
        set_text(LANG .. 'nameLocked', 'Nome gruppo bloccato.')
        set_text(LANG .. 'nameAlreadyUnlocked', 'Nome gruppo già sbloccato.')
        set_text(LANG .. 'nameUnlocked', 'Nome gruppo sbloccato.')
        set_text(LANG .. 'photoLock', '\nBlocco foto: ')
        set_text(LANG .. 'photoAlreadyLocked', 'Foto gruppo già bloccata.')
        set_text(LANG .. 'photoLocked', 'Foto gruppo bloccata.')
        set_text(LANG .. 'photoAlreadyUnlocked', 'Foto gruppo già sbloccata.')
        set_text(LANG .. 'photoUnlocked', 'Foto gruppo sbloccata.')
        set_text(LANG .. 'membersLock', '\nBlocco membri: ')
        set_text(LANG .. 'membersAlreadyLocked', 'Membri gruppo già bloccati.')
        set_text(LANG .. 'membersLocked', 'Membri gruppo bloccati.')
        set_text(LANG .. 'membersAlreadyUnlocked', 'Membri gruppo già sbloccati.')
        set_text(LANG .. 'membersUnlocked', 'Membri gruppo sbloccati.')
        set_text(LANG .. 'leaveLock', '\nBlocco abbandono: ')
        set_text(LANG .. 'leaveAlreadyLocked', 'Uscita già punita col ban.')
        set_text(LANG .. 'leaveLocked', 'Uscita punita col ban.')
        set_text(LANG .. 'leaveAlreadyUnlocked', 'Uscita già consentita.')
        set_text(LANG .. 'leaveUnlocked', 'Uscita consentita.')
        set_text(LANG .. 'spamLock', '\nBlocco spam: ')
        set_text(LANG .. 'spamAlreadyLocked', 'Spam già vietato.')
        set_text(LANG .. 'spamLocked', 'Spam vietato.')
        set_text(LANG .. 'spamAlreadyUnlocked', 'Spam già consentito.')
        set_text(LANG .. 'spamUnlocked', 'Spam consentito.')
        set_text(LANG .. 'floodSensibility', '\nSensibilità flood: ')
        set_text(LANG .. 'floodUnlockOwners', 'Solo i proprietari possono sbloccare il flood.')
        set_text(LANG .. 'floodLock', '\nBlocco flood: ')
        set_text(LANG .. 'floodAlreadyLocked', 'Flood già bloccato.')
        set_text(LANG .. 'floodLocked', 'Flood bloccato.')
        set_text(LANG .. 'floodAlreadyUnlocked', 'Flood già sbloccato.')
        set_text(LANG .. 'floodUnlocked', 'Flood sbloccato.')
        set_text(LANG .. 'arabicLock', '\nBlocco arabo: ')
        set_text(LANG .. 'arabicAlreadyLocked', 'Arabo già vietato.')
        set_text(LANG .. 'arabicLocked', 'Arabo vietato.')
        set_text(LANG .. 'arabicAlreadyUnlocked', 'Arabo già consentito.')
        set_text(LANG .. 'arabicUnlocked', 'Arabo consentito.')
        set_text(LANG .. 'botsLock', '\nBlocco bot: ')
        set_text(LANG .. 'botsAlreadyLocked', 'Bots già vietati.')
        set_text(LANG .. 'botsLocked', 'Bots vietati.')
        set_text(LANG .. 'botsAlreadyUnlocked', 'Bots già consentiti.')
        set_text(LANG .. 'botsUnlocked', 'Bots consentiti.')
        set_text(LANG .. 'linksLock', '\nBlocco link: ')
        set_text(LANG .. 'linksAlreadyLocked', 'Link già vietati.')
        set_text(LANG .. 'linksLocked', 'Link vietati.')
        set_text(LANG .. 'linksAlreadyUnlocked', 'Link già consentiti.')
        set_text(LANG .. 'linksUnlocked', 'Link consentiti.')
        set_text(LANG .. 'rtlLock', '\nBlocco RTL: ')
        set_text(LANG .. 'rtlAlreadyLocked', 'Caratteri RTL già vietati.')
        set_text(LANG .. 'rtlLocked', 'Caratteri RTL vietati.')
        set_text(LANG .. 'rtlAlreadyUnlocked', 'Caratteri RTL già consentiti.')
        set_text(LANG .. 'rtlUnlocked', 'Caratteri RTL consentiti.')
        set_text(LANG .. 'tgserviceLock', '\nBlocco messaggi di servizio: ')
        set_text(LANG .. 'tgserviceAlreadyLocked', 'Messaggi di servizio già bloccati.')
        set_text(LANG .. 'tgserviceLocked', 'Messaggi di servizio bloccati.')
        set_text(LANG .. 'tgserviceAlreadyUnlocked', 'Messaggi di servizio già sbloccati.')
        set_text(LANG .. 'tgserviceUnlocked', 'Messaggi di servizio sbloccati.')
        set_text(LANG .. 'stickersLock', '\nBlocco stickers: ')
        set_text(LANG .. 'stickersAlreadyLocked', 'Stickers già vietati.')
        set_text(LANG .. 'stickersLocked', 'Stickers vietati.')
        set_text(LANG .. 'stickersAlreadyUnlocked', 'Stickers già consentiti.')
        set_text(LANG .. 'stickersUnlocked', 'Stickers consentiti.')
        set_text(LANG .. 'public', '\nPubblico: ')
        set_text(LANG .. 'publicAlreadyYes', 'Gruppo già pubblico.')
        set_text(LANG .. 'publicYes', 'Gruppo pubblico.')
        set_text(LANG .. 'publicAlreadyNo', 'Gruppo già privato.')
        set_text(LANG .. 'publicNo', 'Gruppo privato.')
        set_text(LANG .. 'contactsAlreadyLocked', 'Condivisione contatti già vietata.')
        set_text(LANG .. 'contactsLocked', 'Condivisione contatti vietata.')
        set_text(LANG .. 'contactsAlreadyUnlocked', 'Condivisione contatti già consentita.')
        set_text(LANG .. 'contactsUnlocked', 'Condivisione contatti consentita.')
        set_text(LANG .. 'strictrules', '\nPugno di ferro: ')
        set_text(LANG .. 'strictrulesAlreadyLocked', 'Pugno di ferro già attivato.')
        set_text(LANG .. 'strictrulesLocked', 'Pugno di ferro attivato.')
        set_text(LANG .. 'strictrulesAlreadyUnlocked', 'Pugno di ferro già disattivato.')
        set_text(LANG .. 'strictrulesUnlocked', 'Pugno di ferro disattivato.')

        -- onservice.lua --
        set_text(LANG .. 'notMyGroup', 'Questo non è un mio gruppo, addio.')

        -- owners.lua --
        set_text(LANG .. 'notTheOwner', 'Non sei il proprietario di questo gruppo.')
        set_text(LANG .. 'noAutoUnban', 'Non puoi unbannarti da solo.')

        -- plugins.lua --
        set_text(LANG .. 'enabled', ' abilitato.')
        set_text(LANG .. 'disabled', ' disabilitato.')
        set_text(LANG .. 'alreadyEnabled', ' già abilitato.')
        set_text(LANG .. 'alreadyDisabled', ' già disabilitato.')
        set_text(LANG .. 'notExist', '  non esiste.')
        set_text(LANG .. 'systemPlugin', '⛔️ Non è possibile disabilitare questo plugin in quanto è necessario per il corretto funzionamento del sistema.')
        set_text(LANG .. 'disabledOnChat', ' disabilitato su questa chat.')
        set_text(LANG .. 'noDisabledPlugin', '❔ Nessun plugin disabilitato su questa chat.')
        set_text(LANG .. 'pluginNotDisabled', '✔️ Questo plugin non è disabilitato su questa chat.')
        set_text(LANG .. 'pluginEnabledAgain', ' nuovamente abilitato.')
        set_text(LANG .. 'pluginsReloaded', '💊 Plugins ricaricati.')

        -- pokedex.lua --
        set_text(LANG .. 'noPoke', 'Nessun pokémon trovato.')
        set_text(LANG .. 'pokeName', 'Nome: ')
        set_text(LANG .. 'pokeWeight', 'Peso: ')
        set_text(LANG .. 'pokeHeight', 'Altezza: ')

        -- ruleta.lua --
        set_text(LANG .. 'ruletadbCreated', 'Database ruleta creato.')
        set_text(LANG .. 'alreadySignedUp', 'Sei già registrato, usa /ruleta per morire.')
        set_text(LANG .. 'signedUp', 'Sei stato registrato, have a nice death.')
        set_text(LANG .. 'ruletaDeleted', 'Sei stato eliminato dalla ruleta.')
        set_text(LANG .. 'requireSignUp', 'Prima di morire devi registrarti, usa /registerme.')
        set_text(LANG .. 'groupAlreadySignedUp', 'Gruppo già registrato.')
        set_text(LANG .. 'groupSignedUp', 'Gruppo registrato con i valori di default (tamburo da 6 con 1 proiettile).')
        set_text(LANG .. 'ruletaGroupDeleted', 'Gruppo disabilitato per ruleta.')
        set_text(LANG .. 'requireGroupSignUp', 'Prima di giocare è necessario far registrare il gruppo, usa /registergroup.')
        set_text(LANG .. 'requirePoints', 'Richiede almeno 11 punti.')
        set_text(LANG .. 'requireZeroPoints', 'Non puoi eliminarti se sei in negativo col punteggio.')
        set_text(LANG .. 'challenge', 'SFIDA')
        set_text(LANG .. 'challenger', 'Sfidante: ')
        set_text(LANG .. 'challenged', 'Sfidato: ')
        set_text(LANG .. 'challengeModTerminated', 'Sfida terminata da un moderatore.')
        set_text(LANG .. 'challengeRejected', 'Lo sfidato ha rifiutato la sfida, codardo!')
        set_text(LANG .. 'cantChallengeYourself', 'Non puoi sfidarti da solo.')
        set_text(LANG .. 'cantChallengeMe', 'Non puoi sfidare me, perderesti di sicuro.')
        set_text(LANG .. 'notAccepted', 'Non ancora accettata.')
        set_text(LANG .. 'accepted', 'In corso.')
        set_text(LANG .. 'roundsLeft', 'Round rimasti: ')
        set_text(LANG .. 'shotsLeft', 'Colpi rimasti: ')
        set_text(LANG .. 'notYourTurn', 'Non è il tuo turno.')
        set_text(LANG .. 'yourTurn', ' sta a te.')
        set_text(LANG .. 'challengeEnd', 'Morto, Sfida terminata.')
        set_text(LANG .. 'noChallenge', 'Nessuna sfida in corso.')
        set_text(LANG .. 'errorOngoingChallenge', 'Impossibile avviare più sfide contemporaneamente.')
        set_text(LANG .. 'challengeSet', 'Sfida avviata, lo sfidato può accettare con /accept o rifiutare con /reject.')
        set_text(LANG .. 'wrongPlayer', 'Non sei tu lo sfidato.')
        set_text(LANG .. 'capsChanged', 'Proiettili nella pistola: ')
        set_text(LANG .. 'challengeCapsChanged', 'Proiettili nella pistola da sfida: ')
        set_text(LANG .. 'cylinderChanged', 'Nuovo tamburo da: ')
        set_text(LANG .. 'challengeCylinderChanged', 'Nuovo tamburo sfida da: ')
        set_text(LANG .. 'errorCapsRange', 'Errore, il range è [1-X].')
        set_text(LANG .. 'errorCylinderRange', 'Errore, il range è [5-10].')
        set_text(LANG .. 'cylinderCapacity', 'Capienza tamburo: ')
        set_text(LANG .. 'challengeCylinderCapacity', 'Capienza tamburo sfida: ')
        set_text(LANG .. 'capsNumber', 'Proiettili: ')
        set_text(LANG .. 'challengeCapsNumber', 'Proiettili sfida: ')
        set_text(LANG .. 'deaths', 'Numero morti: ')
        set_text(LANG .. 'duels', 'Sfide totali: ')
        set_text(LANG .. 'wonduels', 'Sfide vinte: ')
        set_text(LANG .. 'lostduels', 'Sfide perse: ')
        set_text(LANG .. 'actualstreak', 'Serie attuale: ')
        set_text(LANG .. 'longeststreak', 'Serie più lunga: ')
        set_text(LANG .. 'attempts', 'Tentativi totali: ')
        set_text(LANG .. 'score', 'Punteggio: ')
        set_text(LANG .. 'cheating', 'Trucco inserito.')
        set_text(LANG .. 'scoreLeaderboard', 'Classifica punti\n')

        -- set.lua --
        set_text(LANG .. 'saved', ' salvato.')
        set_text(LANG .. 'sendMedia', 'Mandami il media che vuoi salvare (audio o foto).')
        set_text(LANG .. 'cancelled', 'Annullato.')
        set_text(LANG .. 'nothingToSet', 'Niente da salvare.')
        set_text(LANG .. 'mediaSaved', 'Media salvato.')

        -- spam.lua --
        set_text(LANG .. 'msgSet', 'Messaggio impostato.')
        set_text(LANG .. 'msgsToSend', 'Messaggi da mandare: ')
        set_text(LANG .. 'timeBetweenMsgs', 'Tempo tra ogni messaggio: X secondi.')
        set_text(LANG .. 'msgNotSet', 'Non hai impostato il messaggio, usa /setspam.')

        -- stats.lua --
        set_text(LANG .. 'usersInChat', 'Utenti in questa chat\n')
        set_text(LANG .. 'groups', '\nGruppi: ')

        -- strings.lua --
        set_text(LANG .. 'langUpdate', 'ℹ️ Stringhe aggiornate.')

        -- supergroup.lua --
        set_text(LANG .. 'makeBotAdmin', 'Promuovimi prima amministratrice!')
        set_text(LANG .. 'groupIs', 'Questo è un gruppo.')
        set_text(LANG .. 'supergroupAlreadyAdded', 'Il supergruppo è già stato aggiunto.')
        set_text(LANG .. 'errorAlreadySupergroup', 'Errore, è già un supergruppo.')
        set_text(LANG .. 'supergroupAdded', 'Il supergruppo è stato aggiunto.')
        set_text(LANG .. 'supergroupRemoved', 'Il supergruppo è stato rimosso.')
        set_text(LANG .. 'supergroupNotAdded', 'Supergruppo non aggiunto.')
        set_text(LANG .. 'membersOf', 'Membri di ')
        set_text(LANG .. 'membersKickedFrom', 'Membri rimossi da ')
        set_text(LANG .. 'cantKickOtherAdmin', 'Non puoi rimuovere altri amministratori.')
        set_text(LANG .. 'promoteSupergroupMod', ' è stato promosso ad amministratore (telegram).')
        set_text(LANG .. 'demoteSupergroupMod', ' è stato degradato da amministratore (telegram).')
        set_text(LANG .. 'alreadySupergroupMod', ' è già un amministratore (telegram).')
        set_text(LANG .. 'notSupergroupMod', ' non è un amministratore (telegram).')
        set_text(LANG .. 'cantDemoteOtherAdmin', 'Non puoi degradare altri amministratori.')
        set_text(LANG .. 'leftKickme', 'Uscito tramite /kickme.')
        set_text(LANG .. 'setOwner', ' ora è l\'owner.')
        set_text(LANG .. 'inThisSupergroup', ' in questo supergruppo.')
        set_text(LANG .. 'sendLink', 'Mandami il link del gruppo.')
        set_text(LANG .. 'linkSaved', 'Nuovo link impostato.')
        set_text(LANG .. 'supergroupUsernameChanged', 'Username supergruppo cambiato.')
        set_text(LANG .. 'errorChangeUsername', 'Errore nell\'impostare l\'username.\nPotrebbe già essere in uso.\n\nPuoi usare lettere numeri e l\'underscore.\nLunghezza minima 5 caratteri.')
        set_text(LANG .. 'usernameCleaned', 'Username gruppo pulito.')
        set_text(LANG .. 'errorCleanedUsername', 'Errore nel tentativo di pulire l\'username.')

        -- unset.lua --
        set_text(LANG .. 'deleted', ' eliminato.')

        -- warn.lua --
        set_text(LANG .. 'errorWarnRange', 'Errore, il range è [1-10].')
        set_text(LANG .. 'warnSet', 'Il warn è stato impostato a ')
        set_text(LANG .. 'noWarnSet', 'Il warn non è ancora stato impostato.')
        set_text(LANG .. 'cantWarnHigher', 'Non puoi avvertire un mod/owner/admin/sudo!')
        set_text(LANG .. 'warned', 'Sei stato avvertito X volte, datti una regolata!')
        set_text(LANG .. 'unwarned', 'Ti è stato tolto un avvertimento, continua così!')
        set_text(LANG .. 'alreadyZeroWarnings', 'Sei già a zero avvertimenti.')
        set_text(LANG .. 'zeroWarnings', 'I tuoi avvertimenti sono stati azzerati.')
        set_text(LANG .. 'yourWarnings', 'Sei a quota X avvertimenti su un massimo di Y.')

        -- welcome.lua --
        set_text(LANG .. 'newWelcome', 'Nuovo messaggio di benvenuto:\n')
        set_text(LANG .. 'newWelcomeNumber', 'Il benvenuto sarà mandato ogni X membri.')
        set_text(LANG .. 'noSetValue', 'Nessun valore impostato.')

        -- whitelist.lua --
        set_text(LANG .. 'userBot', 'Utente/Bot ')
        set_text(LANG .. 'whitelistRemoved', ' rimosso dalla whitelist.')
        set_text(LANG .. 'whitelistAdded', ' aggiunto alla whitelist.')
        set_text(LANG .. 'whitelistCleaned', 'Whitelist svuotata.')

        ------------
        -- Usages --
        ------------
        -- administrator.lua --
        set_text(LANG .. 'administrator:0', 20)
        set_text(LANG .. 'administrator:1', 'ADMIN')
        set_text(LANG .. 'administrator:2', '(#pm|sasha messaggia) <user_id> <msg>: Sasha invia <msg> a <user_id>.')
        set_text(LANG .. 'administrator:3', '#import <group_link>: Sasha entra nel gruppo tramite <group_link>.')
        set_text(LANG .. 'administrator:4', '(#block|sasha blocca) <user_id>: Sasha blocca <user_id>.')
        set_text(LANG .. 'administrator:5', '(#unblock|sasha sblocca) <user_id>: Sasha sblocca <user_id>.')
        set_text(LANG .. 'administrator:6', '(#markread|sasha segna letto) (on|off): Sasha segna come [non] letti i messaggi ricevuti.')
        set_text(LANG .. 'administrator:7', '(#setbotphoto|sasha cambia foto): Sasha chiede la foto da settare come profilo.')
        set_text(LANG .. 'administrator:8', '(#updateid|sasha aggiorna longid): Sasha salva il long_id.')
        set_text(LANG .. 'administrator:9', '(#addlog|sasha aggiungi log): Sasha aggiunge il log.')
        set_text(LANG .. 'administrator:10', '(#remlog|sasha rimuovi log): Sasha rimuove il log.')
        set_text(LANG .. 'administrator:11', 'SUDO')
        set_text(LANG .. 'administrator:12', '(#contactlist|sasha lista contatti) (txt|json): Sasha manda la lista dei contatti.')
        set_text(LANG .. 'administrator:13', '(#dialoglist|sasha lista chat) (txt|json): Sasha manda la lista delle chat.')
        set_text(LANG .. 'administrator:14', '(#addcontact|sasha aggiungi contatto) <phone> <name> <surname>: Sasha aggiunge il contatto specificato.')
        set_text(LANG .. 'administrator:15', '(#delcontact|sasha elimina contatto) <user_id>: Sasha elimina il contatto <user_id>.')
        set_text(LANG .. 'administrator:16', '(#sendcontact|sasha invia contatto) <phone> <name> <surname>: Sasha invia il contatto specificato.')
        set_text(LANG .. 'administrator:17', '(#mycontact|sasha mio contatto): Sasha invia il contatto del richiedente.')
        set_text(LANG .. 'administrator:18', '(#sync_gbans|sasha sincronizza superban): Sasha sincronizza la lista dei superban con quella offerta da TeleSeed.')
        set_text(LANG .. 'administrator:19', '(#backup|sasha esegui backup): Sasha esegue un backup di se stessa e invia il log al richiedente.')
        set_text(LANG .. 'administrator:20', '#vardump [<reply>|<msg_id>]: Sasha esegue il vardump del messaggio specificato.')

        -- anti_spam.lua --
        set_text(LANG .. 'anti_spam:0', 1)
        set_text(LANG .. 'anti_spam:1', 'Sasha rimuove l\'utente che spamma oltre al massimo consentito.')

        -- apod.lua --
        set_text(LANG .. 'apod:0', 4)
        set_text(LANG .. 'apod:1', '#(apod|astro) [<date>]: Sasha manda l\'APOD.')
        set_text(LANG .. 'apod:2', '#(apod|astro)hd [<date>]: Sasha manda l\'APOD in HD.')
        set_text(LANG .. 'apod:3', '#(apod|astro)text [<date>]: Sasha manda la spiegazione dell\'APOD.')
        set_text(LANG .. 'apod:4', 'Se c\'è <date> ed è nel formato AAAA-MM-GG l\'APOD è di <date>.')

        -- arabic_lock.lua --
        set_text(LANG .. 'arabic_lock:0', 1)
        set_text(LANG .. 'arabic_lock:1', 'Sasha blocca l\'arabo nei gruppi.')

        -- banhammer.lua --
        set_text(LANG .. 'banhammer:0', 12)
        set_text(LANG .. 'banhammer:1', '(#kickme|sasha uccidimi): Sasha rimuove l\'utente.')
        set_text(LANG .. 'banhammer:2', 'MOD')
        set_text(LANG .. 'banhammer:3', '(#kick|spara|[sasha] uccidi) <id>|<username>|<reply>: Sasha rimuove l\'utente specificato.')
        set_text(LANG .. 'banhammer:4', '(#ban|esplodi|kaboom|[sasha] banna|[sasha] decompila) <id>|<username>|<reply>: Sasha banna l\'utente specificato e lo rimuove, se tenta di rientrare viene nuovamente rimosso.')
        set_text(LANG .. 'banhammer:5', '(#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>: Sasha sbanna l\'utente specificato.')
        set_text(LANG .. 'banhammer:6', '(#banlist|[sasha] lista ban) [<group_id>]: Sasha mostra la lista di utenti bannati dal gruppo o da <group_id>.')
        set_text(LANG .. 'banhammer:7', 'OWNER')
        set_text(LANG .. 'banhammer:8', '(#kicknouser|[sasha] uccidi nouser|spara nouser): Sasha rimuove gli utenti senza username.')
        set_text(LANG .. 'banhammer:9', 'SUPPORT')
        set_text(LANG .. 'banhammer:10', '(#gban|[sasha] superbanna) <id>|<username>|<reply>: Sasha superbanna l\'utente specificato e lo rimuove, se tenta di rientrare viene nuovamente rimosso.')
        set_text(LANG .. 'banhammer:11', '(#ungban|[sasha] supersbanna) <id>|<username>|<reply>: Sasha supersbanna l\'utente specificato.')
        set_text(LANG .. 'banhammer:12', '(#gbanlist|[sasha] lista superban): Sasha mostra la lista di utenti super bannati.')

        -- bot.lua --
        set_text(LANG .. 'bot:0', 2)
        set_text(LANG .. 'bot:1', 'OWNER')
        set_text(LANG .. 'bot:2', '#bot|sasha on|off: Sasha si attiva|disattiva.')

        -- broadcast.lua --
        set_text(LANG .. 'broadcast:0', 4)
        set_text(LANG .. 'broadcast:1', 'ADMIN')
        set_text(LANG .. 'broadcast:2', '#br <group_id> <text>: Sasha invia <text> a <group_id>.')
        set_text(LANG .. 'broadcast:3', 'SUDO')
        set_text(LANG .. 'broadcast:4', '#broadcast <text>: Sasha invia <text> a tutti i gruppi.')

        -- dogify.lua --
        set_text(LANG .. 'dogify:0', 1)
        set_text(LANG .. 'dogify:1', '(#dogify|[sasha] doge) <your/words/with/slashes>: Sasha crea un\'immagine col doge e le parole specificate.')

        -- echo.lua --
        set_text(LANG .. 'echo:0', 2)
        set_text(LANG .. 'echo:1', 'MOD')
        set_text(LANG .. 'echo:2', '(#echo|sasha ripeti) <text>: Sasha ripete <text>.')

        -- feedback.lua --
        set_text(LANG .. 'feedback:0', 1)
        set_text(LANG .. 'feedback:1', '#feedback <text>: Sasha invia <text> al suo creatore.')

        -- filemanager.lua --
        set_text(LANG .. 'filemanager:0', 15)
        set_text(LANG .. 'filemanager:1', 'SUDO')
        set_text(LANG .. 'filemanager:2', '#folder: Sasha manda la directory attuale.')
        set_text(LANG .. 'filemanager:3', '#cd [<directory>]: Sasha entra in <directory>, se non è specificata torna alla cartella base.')
        set_text(LANG .. 'filemanager:4', '#ls: Sasha manda la lista di file e cartelle della directory corrente.')
        set_text(LANG .. 'filemanager:5', '#mkdir <directory>: Sasha crea <directory>.')
        set_text(LANG .. 'filemanager:6', '#rmdir <directory>: Sasha elimina <directory>.')
        set_text(LANG .. 'filemanager:7', '#rm <file>: Sasha elimina <file>.')
        set_text(LANG .. 'filemanager:8', '#touch <file>: Sasha crea <file>.')
        set_text(LANG .. 'filemanager:9', '#cat <file>: Sasha manda il contenuto di <file>.')
        set_text(LANG .. 'filemanager:10', '#tofile <file> <text>: Sasha crea <file> con <text> come contenuto.')
        set_text(LANG .. 'filemanager:11', '#shell <command>: Sasha esegue <command>.')
        set_text(LANG .. 'filemanager:12', '#cp <file> <directory>: Sasha copia <file> in <directory>.')
        set_text(LANG .. 'filemanager:13', '#mv <file> <directory>: Sasha sposta <file> in <directory>.')
        set_text(LANG .. 'filemanager:14', '#upload <file>: Sasha manda <file> nella chat.')
        set_text(LANG .. 'filemanager:15', '#download <reply>: Sasha scarica il file contenuto in <reply>.')

        -- flame.lua --
        set_text(LANG .. 'flame:0', 4)
        set_text(LANG .. 'flame:1', 'MOD')
        set_text(LANG .. 'flame:2', '(#startflame|[sasha] flamma) <id>|<username>|<reply>: Sasha flamma l\'utente specificato.')
        set_text(LANG .. 'flame:3', '(#stopflame|[sasha] stop flame): Sasha smette di flammare.')
        set_text(LANG .. 'flame:4', '(#flameinfo|[sasha] info flame): Sasha manda le info su chi sta flammando.')

        -- get.lua --
        set_text(LANG .. 'get:0', 1)
        set_text(LANG .. 'get:1', '(#getlist|#get|sasha lista): Sasha mostra una lista delle variabili settate.')
        set_text(LANG .. 'get:2', '[#get] <var_name>: Sasha manda il valore di <var_name>.')

        -- google.lua --
        set_text(LANG .. 'google:0', 2)
        set_text(LANG .. 'google:1', '(#google|[sasha] googla) <terms>: Sasha cerca <terms> su Google e manda i risultati.')

        -- help.lua --
        set_text(LANG .. 'help:0', 6)
        set_text(LANG .. 'help:1', '(#sudolist|sasha lista sudo): Sasha manda la lista dei sudo.')
        set_text(LANG .. 'help:2', '#getrank|rango [<id>|<username>|<reply>]: Sasha manda il rank dell\'utente.')
        set_text(LANG .. 'help:3', '(#help|sasha aiuto): Sasha mostra una lista dei plugin disponibili.')
        set_text(LANG .. 'help:4', '(#help|commands|sasha aiuto) <plugin_name>|<plugin_number> [<fake_rank>]: Sasha mostra l\'aiuto per il plugin specificato.')
        set_text(LANG .. 'help:5', '(#helpall|allcommands|sasha aiuto tutto) [<fake_rank>]: Sasha mostra tutti i comandi di tutti i plugin.')
        set_text(LANG .. 'help:6', 'Il parametro <fake_rank> serve per mandare l\'help di un rango più basso, i ranghi sono: USER, MOD, OWNER, SUPPORT, ADMIN, SUDO.')

        -- info.lua --
        set_text(LANG .. 'info:0', 9)
        set_text(LANG .. 'info:1', '(#info|[sasha] info): Sasha manda le info dell\'utente e della chat o di se stessa')
        set_text(LANG .. 'info:2', 'MOD')
        set_text(LANG .. 'info:3', '(#info|[sasha] info) <id>|<username>|<reply>|from: Sasha manda le info dell\'utente specificato.')
        set_text(LANG .. 'info:4', '(#who|#members|[sasha] lista membri): Sasha manda la lista degli utenti.')
        set_text(LANG .. 'info:5', '(#kicked|[sasha] lista rimossi): Sasha manda la lista degli utenti rimossi.')
        set_text(LANG .. 'info:6', 'OWNER')
        set_text(LANG .. 'info:7', '(#groupinfo|[sasha] info gruppo) [<group_id>]: Sasha manda le info del gruppo specificato.')
        set_text(LANG .. 'info:8', 'SUDO')
        set_text(LANG .. 'info:9', '(#database|[sasha] database): Sasha salva i dati di tutti gli utenti.')

        -- ingroup.lua --
        set_text(LANG .. 'ingroup:0', 33)
        set_text(LANG .. 'ingroup:1', '(#rules|sasha regole): Sasha mostra le regole del gruppo.')
        set_text(LANG .. 'ingroup:2', '(#about|sasha descrizione): Sasha mostra la descrizione del gruppo.')
        set_text(LANG .. 'ingroup:3', '(#modlist|[sasha] lista mod): Sasha mostra la lista dei moderatori.')
        set_text(LANG .. 'ingroup:4', '#owner: Sasha mostra l\'id del proprietario del gruppo.')
        set_text(LANG .. 'ingroup:5', 'MOD')
        set_text(LANG .. 'ingroup:6', '#setname|#setgpname <group_name>: Sasha imposta il nome del gruppo con <group_name>.')
        set_text(LANG .. 'ingroup:7', '#setphoto|#setgpphoto: Sasha imposta e blocca la foto del gruppo.')
        set_text(LANG .. 'ingroup:8', '(#setrules|sasha imposta regole) <text>: Sasha imposta <text> come regole.')
        set_text(LANG .. 'ingroup:9', '(#setabout|sasha imposta descrizione) <text>: Sasha imposta <text> come descrizione.')
        set_text(LANG .. 'ingroup:10', '(#lock|[sasha] blocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha blocca l\'opzione specificata.')
        set_text(LANG .. 'ingroup:11', '(#unlock|[sasha] sblocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha sblocca l\'opzione specificata.')
        set_text(LANG .. 'ingroup:12', '#muteuser|voce <id>|<username>|<reply>: Sasha imposta|toglie il muto sull\'utente.')
        set_text(LANG .. 'ingroup:13', '(#muteslist|lista muti): Sasha manda la lista delle variabili mute della chat.')
        set_text(LANG .. 'ingroup:14', '(#mutelist|lista utenti muti): Sasha manda la lista degli utenti muti della chat.')
        set_text(LANG .. 'ingroup:15', '#settings: Sasha mostra le impostazioni del gruppo.')
        set_text(LANG .. 'ingroup:16', '#public yes|no: Sasha imposta il gruppo come pubblico|privato.')
        set_text(LANG .. 'ingroup:17', '(#newlink|sasha crea link): Sasha crea il link del gruppo.')
        set_text(LANG .. 'ingroup:18', '(#link|sasha link): Sasha mostra il link del gruppo.')
        set_text(LANG .. 'ingroup:19', '#setflood <value>: Sasha imposta il flood massimo del gruppo a <value>.')
        set_text(LANG .. 'ingroup:20', '(#kickinactive [<msgs>]|sasha uccidi sotto <msgs> messaggi): Sasha rimuove tutti gli utenti inattivi.')
        set_text(LANG .. 'ingroup:21', 'OWNER')
        set_text(LANG .. 'ingroup:22', '(#setlink|[sasha] imposta link): Sasha imposta il link d\'invito con quello che le verrà inviato.')
        set_text(LANG .. 'ingroup:23', '(#promote|[sasha] promuovi) <username>|<reply>: Sasha promuove a moderatore l\'utente specificato.')
        set_text(LANG .. 'ingroup:24', '(#demote|[sasha] degrada) <username>|<reply>: Sasha degrada l\'utente specificato.')
        set_text(LANG .. 'ingroup:25', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha imposta il muto sulla variabile specificata.')
        set_text(LANG .. 'ingroup:26', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha rimuove il muto sulla variabile specificata.')
        set_text(LANG .. 'ingroup:27', '#setowner <id>: Sasha imposta <id> come proprietario.')
        set_text(LANG .. 'ingroup:28', '#clean modlist|rules|about: Sasha pulisce il parametro specificato.')
        set_text(LANG .. 'ingroup:29', 'ADMIN')
        set_text(LANG .. 'ingroup:30', '#add [realm]: Sasha aggiunge il gruppo|regno.')
        set_text(LANG .. 'ingroup:31', '#rem [realm]: Sasha rimuove il gruppo|regno.')
        set_text(LANG .. 'ingroup:32', '#kill chat|realm: Sasha elimina ogni utente nel gruppo|regno e poi lo chiude.')
        set_text(LANG .. 'ingroup:33', '#setgpowner <group_id> <user_id>: Sasha imposta <user_id> come proprietario.')

        -- inpm.lua --
        set_text(LANG .. 'inpm:0', 10)
        set_text(LANG .. 'inpm:1', '#chats: Sasha mostra un elenco di chat "pubbliche".')
        set_text(LANG .. 'inpm:2', '#chatlist: Sasha manda un file con un elenco di chat "pubbliche".')
        set_text(LANG .. 'inpm:3', 'ADMIN')
        set_text(LANG .. 'inpm:4', '#join <chat_id>|<alias> [support]: Sasha tenta di aggiungere l\'utente a <chat_id>|<alias>.')
        set_text(LANG .. 'inpm:5', '#getaliaslist: Sasha manda la lista degli alias.')
        set_text(LANG .. 'inpm:6', 'SUDO')
        set_text(LANG .. 'inpm:7', '#allchats: Sasha mostra l\'elenco delle chat.')
        set_text(LANG .. 'inpm:8', '#allchatlist: Sasha manda un file con l\'elenco delle chat.')
        set_text(LANG .. 'inpm:9', '#setalias <alias> <group_id>: Sasha imposta <alias> come alias di <group_id>.')
        set_text(LANG .. 'inpm:10', '#unsetalias <alias>: Sasha elimina <alias>.')

        -- inrealm.lua --
        set_text(LANG .. 'inrealm:0', 26)
        set_text(LANG .. 'inrealm:1', 'MOD')
        set_text(LANG .. 'inrealm:2', '#who: Sasha mostra una lista di membri del gruppo/regno.')
        set_text(LANG .. 'inrealm:3', '#wholist: Sasha invia un file con una lista di membri del gruppo/regno.')
        set_text(LANG .. 'inrealm:4', 'OWNER')
        set_text(LANG .. 'inrealm:5', '#log: Sasha manda un file contenente il log del gruppo/regno.')
        set_text(LANG .. 'inrealm:6', 'ADMIN')
        set_text(LANG .. 'inrealm:7', '(#creategroup|sasha crea gruppo) <group_name>: Sasha crea un gruppo col nome specificato.')
        set_text(LANG .. 'inrealm:8', '(#createsuper|sasha crea supergruppo) <group_name>: Sasha crea un supergruppo col nome specificato.')
        set_text(LANG .. 'inrealm:9', '(#createrealm|sasha crea regno) <realm_name>: Sasha crea un regno col nome specificato.')
        set_text(LANG .. 'inrealm:10', '(#setabout|sasha imposta descrizione) <group_id> <text>: Sasha cambia la descrizione di <group_id> in <text>.')
        set_text(LANG .. 'inrealm:11', '(#setrules|sasha imposta regole) <group_id> <text>: Sasha cambia le regole di <group_id> in <text>.')
        set_text(LANG .. 'inrealm:12', '#setname <realm_name>: Sasha cambia il nome del regno in <realm_name>.')
        set_text(LANG .. 'inrealm:13', '#setname|#setgpname <group_id> <group_name>: Sasha cambia il nome di <group_id> in <group_name>.')
        set_text(LANG .. 'inrealm:14', '(#lock|[sasha] blocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha blocca l\'impostazione specificata di <group_id>.')
        set_text(LANG .. 'inrealm:15', '(#unlock|[sasha] sblocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha sblocca l\'impostazione specificata di <group_id>.')
        set_text(LANG .. 'inrealm:16', '#settings <group_id>: Sasha manda le impostazioni di <group_id>.')
        set_text(LANG .. 'inrealm:17', '#type: Sasha mostra il tipo del gruppo.')
        set_text(LANG .. 'inrealm:18', '#kill chat <group_id>: Sasha rimuove tutti i membri di <group_id> e <group_id>.')
        set_text(LANG .. 'inrealm:19', '#kill realm <realm_id>: Sasha rimuove tutti i membri di <realm_id> e <realm_id>.')
        set_text(LANG .. 'inrealm:20', '#rem <group_id>: Sasha rimuove il gruppo.')
        set_text(LANG .. 'inrealm:21', '#support <user_id>|<username>: Sasha promuove l\'utente specificato a supporto.')
        set_text(LANG .. 'inrealm:22', '#-support <user_id>|<username>: Sasha degrada l\'utente specificato.')
        set_text(LANG .. 'inrealm:23', '#list admins|groups|realms: Sasha mostra una lista della variabile specificata.')
        set_text(LANG .. 'inrealm:24', 'SUDO')
        set_text(LANG .. 'inrealm:25', '#addadmin <user_id>|<username>: Sasha promuove l\'utente specificato ad amminstratore.')
        set_text(LANG .. 'inrealm:26', '#removeadmin <user_id>|<username>: Sasha degrada l\'utente specificato.')

        -- interact.lua --
        set_text(LANG .. 'interact:0', 1)
        set_text(LANG .. 'interact:1', 'Sasha interagisce con gli utenti.')

        -- invite.lua --
        set_text(LANG .. 'invite:0', 2)
        -- set_text(LANG .. 'invite:1','OWNER')
        set_text(LANG .. 'invite:1', 'ADMIN')
        set_text(LANG .. 'invite:2', '(#invite|[sasha] invita|[sasha] resuscita) <id>|<username>|<reply>: Sasha invita l\'utente specificato.')

        -- leave_ban.lua --
        set_text(LANG .. 'leave_ban:0', 1)
        set_text(LANG .. 'leave_ban:1', 'Sasha banna l\'utente che esce dal gruppo.')

        -- msg_checks.lua --
        set_text(LANG .. 'msg_checks:0', 1)
        set_text(LANG .. 'msg_checks:1', 'Sasha controlla i messaggi che riceve.')

        -- onservice.lua --
        set_text(LANG .. 'onservice:0', 2)
        set_text(LANG .. 'onservice:1', 'ADMIN')
        set_text(LANG .. 'onservice:2', '(#leave|sasha abbandona): Sasha lascia il gruppo.')

        -- owners.lua --
        set_text(LANG .. 'owners:0', 5)
        -- set_text(LANG .. 'owners:1','#owners <group_id>: Sasha invia il log di <group_id>.')
        set_text(LANG .. 'owners:1', '#changeabout <group_id> <text>: Sasha cambia la descrizione di <group_id> con <text>.')
        set_text(LANG .. 'owners:2', '#changerules <group_id> <text>: Sasha cambia le regole di <group_id> con <text>.')
        set_text(LANG .. 'owners:3', '#changename <group_id> <text>: Sasha cambia il nome di <group_id> con <text>.')
        set_text(LANG .. 'owners:4', '#viewsettings <group_id>: Sasha manda le impostazioni di <group_id>.')
        set_text(LANG .. 'owners:5', '#loggroup <group_id>: Sasha invia il log di <group_id>.')

        -- plugins.lua --
        set_text(LANG .. 'plugins:0', 9)
        set_text(LANG .. 'plugins:1', 'OWNER')
        set_text(LANG .. 'plugins:2', '(#disabledlist|([sasha] lista disabilitati|disattivati)): Sasha mostra una lista dei plugins disabilitati su questa chat.')
        set_text(LANG .. 'plugins:3', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> chat: Sasha riabilita <plugin> su questa chat.')
        set_text(LANG .. 'plugins:4', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> chat: Sasha disabilita <plugin> su questa chat.')
        set_text(LANG .. 'plugins:5', 'SUDO')
        set_text(LANG .. 'plugins:6', '(#plugins|[sasha] lista plugins): Sasha mostra una lista di tutti i plugins.')
        set_text(LANG .. 'plugins:7', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> [chat]: Sasha abilita <plugin>, se specificato solo su questa chat.')
        set_text(LANG .. 'plugins:8', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> [chat]: Sasha disabilita <plugin>, se specificato solo su questa chat.')
        set_text(LANG .. 'plugins:9', '(#[plugin[s]] reload|[sasha] ricarica): Sasha ricarica tutti i plugins.')

        -- pokedex.lua --
        set_text(LANG .. 'pokedex:0', 1)
        set_text(LANG .. 'pokedex:1', '#pokedex|#pokemon <name>|<id>: Sasha cerca il pokémon specificato e ne invia le informazioni.')

        -- qr.lua --
        set_text(LANG .. 'qr:0', 5)
        set_text(LANG .. 'qr:1', '(#qr|sasha qr) ["<background_color>" "<data_color>"] <text>: Sasha crea il QR Code di <text>, se specificato colora il QR Code.')
        set_text(LANG .. 'qr:2', 'I colori possono essere specificati come segue:')
        set_text(LANG .. 'qr:3', 'Testo => red|green|blue|purple|black|white|gray.')
        set_text(LANG .. 'qr:4', 'Notazione Esadecimale => ("a56729" è marrone).')
        set_text(LANG .. 'qr:5', 'Notazione Decimale => ("255-192-203" è rosa).')

        -- reactions.lua --
        set_text(LANG .. 'reactions:0', 2)
        set_text(LANG .. 'reactions:1', 'SUDO')
        set_text(LANG .. 'reactions:2', '#writing on|off: Sasha (fa finta|smette di far finta) di scrivere.')

        -- ruleta.lua --
        set_text(LANG .. 'ruleta:0', 24)
        set_text(LANG .. 'ruleta:1', 'Ruleta by AISasha, inspired from Leia (#RIP) and Arya. Ruleta è la roulette russa con la pistola, tamburo da tot colpi con tot proiettili al suo interno, si gira il tamburo e se c\'è il proiettile sei fuori altrimenti rimani.')
        set_text(LANG .. 'ruleta:2', '#registerme|#registrami: Sasha registra l\'utente alla roulette.')
        set_text(LANG .. 'ruleta:3', '#deleteme|#eliminami: Sasha elimina i dati dell\'utente.')
        set_text(LANG .. 'ruleta:4', '#ruletainfo: Sasha manda le informazioni della roulette.')
        set_text(LANG .. 'ruleta:5', '#mystats|#punti: Sasha manda le statistiche dell\'utente.')
        set_text(LANG .. 'ruleta:6', '#ruleta: Sasha cerca di ucciderti.')
        set_text(LANG .. 'ruleta:7', '#godruleta: Sasha ti dà il 50% di probabilità di guadagnare 70 punti, con l\'altro 50% li perdi tutti (richiede almeno 11 punti).')
        set_text(LANG .. 'ruleta:8', '#challenge|#sfida <username>|<reply>: Sasha avvia una sfida tra il mittente e l\'utente specificato.')
        set_text(LANG .. 'ruleta:9', '#accept|#accetta: Sasha conferma la sfida.')
        set_text(LANG .. 'ruleta:10', '#reject|#rifiuta: Sasha cancella la sfida.')
        set_text(LANG .. 'ruleta:11', '#challengeinfo: Sasha manda le informazioni della sfida in corso.')
        set_text(LANG .. 'ruleta:12', 'MOD')
        set_text(LANG .. 'ruleta:13', '#setcaps <value>: Sasha mette <value> proiettili nel tamburo.')
        set_text(LANG .. 'ruleta:14', '#setchallengecaps <value>: Sasha mette <value> proiettili nel tamburo delle sfide.')
        set_text(LANG .. 'ruleta:15', '(#kick|spara|[sasha] uccidi) random: Sasha sceglie un utente a caso e lo rimuove.')
        set_text(LANG .. 'ruleta:16', 'OWNER')
        set_text(LANG .. 'ruleta:17', '#setcylinder <value>: Sasha imposta un tamburo da <value> colpi nel range [5-10].')
        set_text(LANG .. 'ruleta:18', '#setchallengecylinder <value>: Sasha imposta un tamburo da <value> colpi per le sfide nel range [5-10].')
        set_text(LANG .. 'ruleta:19', 'ADMIN')
        set_text(LANG .. 'ruleta:20', '#registergroup|#registragruppo: Sasha abilita il gruppo a giocare a ruleta.')
        set_text(LANG .. 'ruleta:21', '#deletegroup|#eliminagruppo: Sasha disabilita il gruppo per ruleta.')
        set_text(LANG .. 'ruleta:22', 'SUDO')
        set_text(LANG .. 'ruleta:23', '#createdb: Sasha crea il database di ruleta.')
        set_text(LANG .. 'ruleta:24', '#addpoints <id> <value>: Sasha aggiunge <value> punti all\'utente specificato.')

        -- set.lua --
        set_text(LANG .. 'set:0', 4)
        set_text(LANG .. 'set:1', 'MOD')
        set_text(LANG .. 'set:2', '(#set|[sasha] setta) <var_name> <text>: Sasha salva <text> come risposta a <var_name>.')
        set_text(LANG .. 'set:3', '(#setmedia|[sasha] setta media) <var_name>: Sasha salva il media (foto o audio) che le verrà inviato come risposta a <var_name>.')
        set_text(LANG .. 'set:4', '(#cancel|[sasha] annulla): Sasha annulla un #setmedia.')

        -- shout.lua --
        set_text(LANG .. 'shout:0', 2)
        set_text(LANG .. 'shout:1', '(#shout|[sasha] grida|[sasha] urla) <text>: Sasha "urla" <text>.')

        -- spam.lua --
        set_text(LANG .. 'spam:0', 5)
        set_text(LANG .. 'spam:1', 'OWNER')
        set_text(LANG .. 'spam:2', '#setspam <text>: Sasha imposta <text> come messaggio da spammare.')
        set_text(LANG .. 'spam:3', '#setmsgs <value>: Sasha imposta <value> come numero di messaggi da spammare.')
        set_text(LANG .. 'spam:4', '#setwait <seconds>: Sasha imposta <seconds> come intervallo di tempo tra i messaggi.')
        set_text(LANG .. 'spam:5', '(#spam|[sasha] spamma): Sasha inizia a spammare.')

        -- stats.lua --
        set_text(LANG .. 'stats:0', 6)
        set_text(LANG .. 'stats:1', '[#]aisasha: Sasha invia la propria descrizione.')
        set_text(LANG .. 'stats:2', 'MOD')
        set_text(LANG .. 'stats:3', '(#stats|#statslist|#messages|sasha statistiche|sasha lista statistiche|sasha messaggi): Sasha invia le statistiche della chat.')
        set_text(LANG .. 'stats:4', 'ADMIN')
        set_text(LANG .. 'stats:5', '(#stats|#statslist|#messages|sasha statistiche|sasha lista statistiche|sasha messaggi) group|gruppo <group_id>: Sasha invia le statistiche relative al gruppo specificato.')
        set_text(LANG .. 'stats:6', '(#stats|#statslist|sasha statistiche|sasha lista statistiche) aisasha: Sasha invia le proprie statistiche.')

        -- strings_en.lua --
        set_text(LANG .. 'strings_en:0', 2)
        set_text(LANG .. 'strings_en:1', 'SUDO')
        set_text(LANG .. 'strings_en:2', '(#updateenstrings|#installenstrings|([sasha] installa|[sasha] aggiorna) stringhe en): Sasha updates strings.')

        -- strings_it.lua --
        set_text(LANG .. 'strings_it:0', 2)
        set_text(LANG .. 'strings_it:1', 'SUDO')
        set_text(LANG .. 'strings_it:2', '(#updateitstrings|#installitstrings|([sasha] installa|[sasha] aggiorna) stringhe it): Sasha aggiorna le stringhe di testo.')

        -- supergroup.lua --
        set_text(LANG .. 'supergroup:0', 45)
        set_text(LANG .. 'supergroup:1', '#owner: Sasha manda il proprietario.')
        set_text(LANG .. 'supergroup:2', '(#modlist|[sasha] lista mod): Sasha manda la lista dei moderatori.')
        set_text(LANG .. 'supergroup:3', '(#rules|sasha regole): Sasha manda le regole del gruppo.')
        set_text(LANG .. 'supergroup:4', 'MOD')
        set_text(LANG .. 'supergroup:5', '(#bots|[sasha] lista bot): Sasha manda la lista dei bot.')
        set_text(LANG .. 'supergroup:6', '#wholist|#memberslist: Sasha manda un file contenente la lista degli utenti.')
        set_text(LANG .. 'supergroup:7', '#kickedlist: Sasha manda la lista degli utenti rimossi.')
        set_text(LANG .. 'supergroup:8', '#del <reply>: Sasha elimina il messaggio specificato.')
        set_text(LANG .. 'supergroup:9', '(#newlink|[sasha] crea link): Sasha crea un nuovo link d\'invito.')
        set_text(LANG .. 'supergroup:10', '(#link|sasha link): Sasha manda il link d\'invito.')
        set_text(LANG .. 'supergroup:11', '#setname|setgpname <text>: Sasha cambia il nome del gruppo con <text>.')
        set_text(LANG .. 'supergroup:12', '#setphoto|setgpphoto: Sasha cambia la foto del gruppo.')
        set_text(LANG .. 'supergroup:13', '(#setrules|sasha imposta regole) <text>: Sasha cambia le regole del gruppo con <text>.')
        set_text(LANG .. 'supergroup:14', '(#setabout|sasha imposta descrizione) <text>: Sasha cambia la descrizione del gruppo con <text>.')
        set_text(LANG .. 'supergroup:15', '(#lock|[sasha] blocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha blocca l\'opzione specificata.')
        set_text(LANG .. 'supergroup:16', '(#unlock|[sasha] sblocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha sblocca l\'opzione specificata.')
        set_text(LANG .. 'supergroup:17', '#setflood <value>: Sasha imposta il flood massimo a <value> che deve essere compreso tra 5 e 20.')
        set_text(LANG .. 'supergroup:18', '#public yes|no: Sasha imposta il gruppo come pubblico|privato.')
        set_text(LANG .. 'supergroup:19', '#muteuser|voce <id>|<username>|<reply>: Sasha imposta|toglie il muto sull\'utente.')
        set_text(LANG .. 'supergroup:20', '(#muteslist|lista muti): Sasha manda la lista delle variabili mute della chat.')
        set_text(LANG .. 'supergroup:21', '(#mutelist|lista utenti muti): Sasha manda la lista degli utenti muti della chat.')
        set_text(LANG .. 'supergroup:22', '#settings: Sasha manda le impostazioni del gruppo.')
        set_text(LANG .. 'supergroup:23', 'OWNER')
        set_text(LANG .. 'supergroup:24', '(#admins|[sasha] lista admin): Sasha manda la lista degli amministratori.')
        set_text(LANG .. 'supergroup:25', '(#setlink|sasha imposta link): Sasha imposta il link d\'invito con quello che le verrà inviato.')
        set_text(LANG .. 'supergroup:26', '#setadmin <id>|<username>|<reply>: Sasha promuove l\'utente specificato ad amministratore (telegram).')
        set_text(LANG .. 'supergroup:27', '#demoteadmin <id>|<username>|<reply>: Sasha degrada l\'utente specificato (telegram).')
        set_text(LANG .. 'supergroup:28', '#setowner <id>|<username>|<reply>: Sasha imposta l\'utente specificato come proprietario.')
        set_text(LANG .. 'supergroup:29', '(#promote|[sasha] promuovi) <id>|<username>|<reply>: Sasha promuove l\'utente specificato a moderatore.')
        set_text(LANG .. 'supergroup:30', '(#demote|[sasha] degrada) <id>|<username>|<reply>: Sasha degrada l\'utente specificato.')
        set_text(LANG .. 'supergroup:31', '#clean rules|about|modlist|mutelist: Sasha azzera la variabile specificata.')
        set_text(LANG .. 'supergroup:32', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha imposta il muto sulla variabile specificata.')
        set_text(LANG .. 'supergroup:33', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha rimuove il muto sulla variabile specificata.')
        set_text(LANG .. 'supergroup:34', 'SUPPORT')
        set_text(LANG .. 'supergroup:35', '#add: Sasha aggiunge il supergruppo.')
        set_text(LANG .. 'supergroup:36', '#rem: Sasha rimuove il supergruppo.')
        set_text(LANG .. 'supergroup:37', 'ADMIN')
        set_text(LANG .. 'supergroup:38', '#tosuper: Sasha aggiorna il gruppo a supergruppo.')
        set_text(LANG .. 'supergroup:39', '#setusername <text>: Sasha cambia l\'username del gruppo con <text>.')
        set_text(LANG .. 'supergroup:40', 'peer_id')
        set_text(LANG .. 'supergroup:41', 'msg.to.id')
        set_text(LANG .. 'supergroup:42', 'msg.to.peer_id')
        set_text(LANG .. 'supergroup:43', 'SUDO')
        set_text(LANG .. 'supergroup:44', '#mp <id>: Sasha promuove <id> a moderatore del gruppo (telegram).')
        set_text(LANG .. 'supergroup:45', '#md <id>: Sasha degrada <id> dal ruolo di moderatore del gruppo (telegram).')

        -- tagall.lua --
        set_text(LANG .. 'tagall:0', 2)
        set_text(LANG .. 'tagall:1', 'OWNER')
        set_text(LANG .. 'tagall:2', '(#tagall|sasha tagga tutti) <text>: Sasha tagga tutti i membri del gruppo con username e scrive <text>.')

        -- tex.lua --
        set_text(LANG .. 'tex:0', 1)
        set_text(LANG .. 'tex:1', '(#tex|[sasha] equazione) <equation>: Sasha converte <equation> in immagine.')

        -- unset.lua --
        set_text(LANG .. 'unset:0', 2)
        set_text(LANG .. 'unset:1', 'MOD')
        set_text(LANG .. 'unset:2', '(#unset|[sasha] unsetta) <var_name>: Sasha elimina <var_name>.')

        -- urbandictionary.lua --
        set_text(LANG .. 'urbandictionary:0', 1)
        set_text(LANG .. 'urbandictionary:1', '(#urbandictionary|#urban|#ud|[sasha] urban|[sasha] ud) <text>: Sasha mostra la definizione di <text> dall\'Urban Dictionary.')

        -- warn.lua --
        set_text(LANG .. 'warn:0', 7)
        set_text(LANG .. 'warn:1', 'MOD')
        set_text(LANG .. 'warn:2', '#setwarn <value>: Sasha imposta gli avvertimenti massimi a <value>.')
        set_text(LANG .. 'warn:3', '#getwarn: Sasha manda il numero di avvertimenti massimi.')
        set_text(LANG .. 'warn:4', '(#getuserwarns|[sasha] ottieni avvertimenti) <id>|<username>|<reply>: Sasha manda il numero di avvertimenti ricevuti dall\'utente.')
        set_text(LANG .. 'warn:5', '(#warn|[sasha] avverti) <id>|<username>|<reply>: Sasha avverte l\'utente.')
        set_text(LANG .. 'warn:6', '#unwarn <id>|<username>|<reply>: Sasha diminuisce di uno gli avvertimenti dell\'utente.')
        set_text(LANG .. 'warn:7', '(#unwarnall|[sasha] azzera avvertimenti) <id>|<username>|<reply>: Sasha azzera gli avvertimenti dell\'utente.')

        -- webshot.lua --
        set_text(LANG .. 'webshot:0', 14)
        set_text(LANG .. 'webshot:1', 'MOD')
        set_text(LANG .. 'webshot:2', '(#webshot|[sasha] webshotta) <url> [<size>]: Sasha esegue uno screenshot di <url> e lo invia, se <size> è specificata di quella dimensione.')
        set_text(LANG .. 'webshot:3', 'La dimensione può essere:')
        set_text(LANG .. 'webshot:4', 'T: (120 x 90px)')
        set_text(LANG .. 'webshot:5', 'S: (200 x 150px)')
        set_text(LANG .. 'webshot:6', 'E: (320 x 240px)')
        set_text(LANG .. 'webshot:7', 'N: (400 x 300px)')
        set_text(LANG .. 'webshot:8', 'M: (640 x 480px)')
        set_text(LANG .. 'webshot:9', 'L: (800 x 600px)')
        set_text(LANG .. 'webshot:10', 'X: (1024 x 768px)')
        set_text(LANG .. 'webshot:11', 'Nmob: (480 x 800px)')
        set_text(LANG .. 'webshot:12', 'ADMIN')
        set_text(LANG .. 'webshot:13', 'F: Pagina intera (può essere un processo molto lungo)')
        set_text(LANG .. 'webshot:14', 'Fmob: Pagina intera (può essere un processo lungo)')

        -- welcome.lua --
        set_text(LANG .. 'welcome:0', 5)
        set_text(LANG .. 'welcome:1', '#getwelcome: Sasha manda il benvenuto.')
        set_text(LANG .. 'welcome:2', 'OWNER')
        set_text(LANG .. 'welcome:3', '#setwelcome <text>: Sasha imposta <text> come benvenuto.')
        set_text(LANG .. 'welcome:4', '#setmemberswelcome <value>: Sasha dopo <value> membri manderà il benvenuto con le regole.')
        set_text(LANG .. 'welcome:5', '#getmemberswelcome: Sasha manda il numero di membri entrati dopo i quali invia il benvenuto.')

        -- whitelist.lua --
        set_text(LANG .. 'whitelist:0', 3)
        set_text(LANG .. 'whitelist:1', 'ADMIN')
        set_text(LANG .. 'whitelist:2', '#whitelist <id>|<username>|<reply>: Sasha aggiunge|rimuove l\'utente specificato alla|dalla whitelist.')
        set_text(LANG .. 'whitelist:3', '#clean whitelist: Sasha pulisce la whitelist.')

        return lang_text('langUpdate')
    else
        return lang_text('require_sudo')
    end
end

return {
    description = "STRINGS",
    patterns =
    {
        '^[#!/]([Ii][Nn][Ss][Tt][Aa][Ll][Ll][Ii][Tt][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        '^[#!/]([Uu][Pp][Dd][Aa][Tt][Ee][Ii][Tt][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        -- installstrings
        '^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ss][Tt][Aa][Ll][Ll][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ii][Tt])$',
        '^([Ii][Nn][Ss][Tt][Aa][Ll][Ll][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ii][Tt])$',
        -- updatestrings
        '^([Ss][Aa][Ss][Hh][Aa] [Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ii][Tt])$',
        '^([Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ii][Tt])$',
    },
    run = run,
    min_rank = 5
    -- usage
    -- SUDO
    -- (#updateitstrings|#installitstrings|([sasha] installa|[sasha] aggiorna) stringhe it)
}