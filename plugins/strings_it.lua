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
        set_text('youTried', 'Ci hai provato, non avrai un help più dettagliato di quello che ti spetta, pezzente.')

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
        set_text('phone', '\nTelefono: ')
        set_text('rank', '\nRango: ')
        set_text('date', '\nData: ')
        set_text('totalMessages', '\nMessaggi totali: ')
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
        set_text('welcomeNewRealm', 'Benvenuto nel tuo nuovo regno.')
        set_text('realmIs', 'Questo è un regno.')
        set_text('realmAdded', 'Il regno è stato aggiunto.')
        set_text('realmAlreadyAdded', 'Il regno è già stato aggiunto.')
        set_text('realmRemoved', 'Il regno è stato rimosso.')
        set_text('realmNotAdded', 'Regno non aggiunto.')
        set_text('errorAlreadyRealm', 'Errore, è già un regno.')
        set_text('errorNotRealm', 'Errore, non è un regno.')
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
        set_text('realmsJoin', 'Reami:\nUsa /join <realm_id> per entrare\n\n')
        set_text('youGbanned', 'Sei bannato globalmente.')
        set_text('youBanned', 'Sei bannato.')
        set_text('chatNotFound', 'Chat non trovata.')
        set_text('privateGroup', 'Gruppo privato.')
        set_text('addedTo', 'Sei stato aggiunto a: ')
        set_text('supportAdded', 'Aggiunto membro di supporto ')
        set_text('adminAdded', 'Aggiunto admin ')
        set_text('toChat', ' a 👥 ')
        set_text('aliasSaved', 'Alias salvato.')
        set_text('aliasDeleted', 'Alias eliminato.')
        set_text('noAliasFound', 'Nessun gruppo trovato con quell\'alias.')

        -- inrealm.lua --
        set_text('realm', 'Regno ')
        set_text('group', 'Gruppo ')
        set_text('created', ' creato.')
        set_text('chatTypeNotFound', 'Tipo chat non trovato.')
        set_text('usersIn', 'Utenti in ')
        set_text('alreadyAdmin', ' è già un admin.')
        set_text('promoteAdmin', ' è stato promosso ad admin.')
        set_text('notAdmin', ' non è un admin.')
        set_text('demoteAdmin', ' è stato degradato da admin.')
        set_text('groupListStart', 'Gruppi:\n')
        set_text('noRealms', 'Nessun regno al momento.')
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
        set_text('errorRealm', 'Errore, regno ')
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
        set_text('notExists', ' non esiste.')
        set_text('systemPlugin', '⛔️ Non è possibile disabilitare questo plugin in quanto è necessario per il corretto funzionamento del sistema.')
        set_text('disabledOnChat', ' disabilitato su questa chat.')
        set_text('noDisabledPlugin', '❔ Nessun plugin disabilitato su questa chat.')
        set_text('pluginNotDisabled', '✔️ Questo plugin non è disabilitato su questa chat.')
        set_text('pluginEnabledAgain', ' nuovamente abilitato.')
        set_text('pluginsReloaded', '💊 Plugins ricaricati.')

        -- pokedex.lua --
        set_text('noPoke', 'Nessun pokémon trovato.')
        set_text('pokeName', 'Nome: ')
        set_text('pokeWeight', 'Peso: ')
        set_text('pokeHeight', 'Altezza: ')

        -- ruleta.lua --
        set_text('ruletadbCreated', 'Database ruleta creato.')
        set_text('alreadySignedUp', 'Sei già registrato, usa /ruleta per morire.')
        set_text('signedUp', 'Sei stato registrato, have a nice death.')
        set_text('ruletaDeleted', 'Sei stato eliminato dalla ruleta.')
        set_text('requireSignUp', 'Prima di morire devi registrarti, usa /registerme.')
        set_text('groupAlreadySignedUp', 'Gruppo già registrato.')
        set_text('groupSignedUp', 'Gruppo registrato con i valori di default (tamburo da 6 con 1 proiettile).')
        set_text('ruletaGroupDeleted', 'Gruppo disabilitato per ruleta.')
        set_text('requireGroupSignUp', 'Prima di giocare è necessario far registrare il gruppo.')
        set_text('requirePoints', 'Richiede almeno 11 punti.')
        set_text('requireZeroPoints', 'Non puoi eliminarti se sei in negativo col punteggio.')
        set_text('challenge', 'SFIDA')
        set_text('challenger', 'Sfidante: ')
        set_text('challenged', 'Sfidato: ')
        set_text('challengeModTerminated', 'Sfida terminata da un moderatore.')
        set_text('challengeRejected', 'Lo sfidato ha rifiutato la sfida, codardo!')
        set_text('cantChallengeYourself', 'Non puoi sfidarti da solo.')
        set_text('cantChallengeMe', 'Non puoi sfidare me, perderesti di sicuro.')
        set_text('notAccepted', 'Non ancora accettata.')
        set_text('accepted', 'In corso.')
        set_text('roundsLeft', 'Round rimasti: ')
        set_text('shotsLeft', 'Colpi rimasti: ')
        set_text('notYourTurn', 'Non è il tuo turno.')
        set_text('yourTurn', ' sta a te.')
        set_text('challengeEnd', 'Morto, Sfida terminata.')
        set_text('noChallenge', 'Nessuna sfida in corso.')
        set_text('errorOngoingChallenge', 'Impossibile avviare più sfide contemporaneamente.')
        set_text('challengeSet', 'Sfida avviata, lo sfidato può accettare con /accept o rifiutare con /reject.')
        set_text('wrongPlayer', 'Non sei tu lo sfidato.')
        set_text('capsChanged', 'Proiettili nella pistola: ')
        set_text('challengeCapsChanged', 'Proiettili nella pistola da sfida: ')
        set_text('cylinderChanged', 'Nuovo tamburo da: ')
        set_text('challengeCylinderChanged', 'Nuovo tamburo sfida da: ')
        set_text('errorCapsRange', 'Errore, il range è [1-X].')
        set_text('errorCylinderRange', 'Errore, il range è [5-10].')
        set_text('cylinderCapacity', 'Capienza tamburo: ')
        set_text('challengeCylinderCapacity', 'Capienza tamburo sfida: ')
        set_text('capsNumber', 'Proiettili: ')
        set_text('challengeCapsNumber', 'Proiettili sfida: ')
        set_text('deaths', 'Numero morti: ')
        set_text('duels', 'Sfide totali: ')
        set_text('wonduels', 'Sfide vinte: ')
        set_text('lostduels', 'Sfide perse: ')
        set_text('actualstreak', 'Serie attuale: ')
        set_text('longeststreak', 'Serie più lunga: ')
        set_text('attempts', 'Tentativi totali: ')
        set_text('score', 'Punteggio: ')
        set_text('cheating', 'Trucco inserito.')
        set_text('scoreLeaderboard', 'Classifica punti\n')

        -- set.lua --
        set_text('saved', ' salvato.')
        set_text('sendMedia', 'Mandami il media che vuoi salvare (audio o foto).')
        set_text('cancelled', 'Annullato.')
        set_text('nothingToSet', 'Niente da salvare.')
        set_text('mediaSaved', 'Media salvato.')

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
        set_text('errorWarnRange', 'Errore, il range è [0-10].')
        set_text('warnSet', 'Il warn è stato impostato a ')
        set_text('neverWarn', 'Gli avvertimenti non funzioneranno più.')
        set_text('noWarnSet', 'Il warn non è ancora stato impostato.')
        set_text('cantWarnHigher', 'Non puoi avvertire un mod/owner/admin/sudo!')
        set_text('warned', 'Sei stato avvertito X volte, datti una regolata!')
        set_text('unwarned', 'Ti è stato tolto un avvertimento, continua così!')
        set_text('alreadyZeroWarnings', 'Sei già a zero avvertimenti.')
        set_text('zeroWarnings', 'I tuoi avvertimenti sono stati azzerati.')
        set_text('yourWarnings', 'Sei a quota X avvertimenti su un massimo di Y.')

        -- welcome.lua --
        set_text('newWelcome', 'Nuovo messaggio di benvenuto:\n')
        set_text('newWelcomeNumber', 'Il benvenuto sarà mandato ogni X membri.')
        set_text('neverWelcome', 'Il messaggio di benvenuto non sarà più mandato.')
        set_text('noSetValue', 'Nessun valore impostato.')

        -- whitelist.lua --
        set_text('userBot', 'Utente/Bot ')
        set_text('whitelistRemoved', ' rimosso dalla whitelist.')
        set_text('whitelistAdded', ' aggiunto alla whitelist.')
        set_text('whitelistCleaned', 'Whitelist svuotata.')

        ------------
        -- Usages --
        ------------
        -- administrator.lua --
        set_text('administrator:0', 20)
        set_text('administrator:1', 'ADMIN')
        set_text('administrator:2', '(#pm|sasha messaggia) <user_id> <msg>: Sasha invia <msg> a <user_id>.')
        set_text('administrator:3', '#import <group_link>: Sasha entra nel gruppo tramite <group_link>.')
        set_text('administrator:4', '(#block|sasha blocca) <user_id>: Sasha blocca <user_id>.')
        set_text('administrator:5', '(#unblock|sasha sblocca) <user_id>: Sasha sblocca <user_id>.')
        set_text('administrator:6', '(#markread|sasha segna letto) (on|off): Sasha segna come [non] letti i messaggi ricevuti.')
        set_text('administrator:7', '(#setbotphoto|sasha cambia foto): Sasha chiede la foto da settare come profilo.')
        set_text('administrator:8', '(#updateid|sasha aggiorna longid): Sasha salva il long_id.')
        set_text('administrator:9', '(#addlog|sasha aggiungi log): Sasha aggiunge il log.')
        set_text('administrator:10', '(#remlog|sasha rimuovi log): Sasha rimuove il log.')
        set_text('administrator:11', 'SUDO')
        set_text('administrator:12', '(#contactlist|sasha lista contatti) (txt|json): Sasha manda la lista dei contatti.')
        set_text('administrator:13', '(#dialoglist|sasha lista chat) (txt|json): Sasha manda la lista delle chat.')
        set_text('administrator:14', '(#addcontact|sasha aggiungi contatto) <phone> <name> <surname>: Sasha aggiunge il contatto specificato.')
        set_text('administrator:15', '(#delcontact|sasha elimina contatto) <user_id>: Sasha elimina il contatto <user_id>.')
        set_text('administrator:16', '(#sendcontact|sasha invia contatto) <phone> <name> <surname>: Sasha invia il contatto specificato.')
        set_text('administrator:17', '(#mycontact|sasha mio contatto): Sasha invia il contatto del richiedente.')
        set_text('administrator:18', '(#sync_gbans|sasha sincronizza superban): Sasha sincronizza la lista dei superban con quella offerta da TeleSeed.')
        set_text('administrator:19', '(#backup|sasha esegui backup): Sasha esegue un backup di se stessa e invia il log al richiedente.')
        set_text('administrator:20', '#vardump [<reply>|<msg_id>]: Sasha esegue il vardump del messaggio specificato.')

        -- anti_spam.lua --
        set_text('anti_spam:0', 1)
        set_text('anti_spam:1', 'Sasha rimuove l\'utente che spamma oltre al massimo consentito.')

        -- apod.lua --
        set_text('apod:0', 4)
        set_text('apod:1', '#(apod|astro) [<date>]: Sasha manda l\'APOD.')
        set_text('apod:2', '#(apod|astro)hd [<date>]: Sasha manda l\'APOD in HD.')
        set_text('apod:3', '#(apod|astro)text [<date>]: Sasha manda la spiegazione dell\'APOD.')
        set_text('apod:4', 'Se c\'è <date> ed è nel formato AAAA-MM-GG l\'APOD è di <date>.')

        -- arabic_lock.lua --
        set_text('arabic_lock:0', 1)
        set_text('arabic_lock:1', 'Sasha blocca l\'arabo nei gruppi.')

        -- banhammer.lua --
        set_text('banhammer:0', 13)
        set_text('banhammer:1', '(#kickme|sasha uccidimi): Sasha rimuove l\'utente.')
        set_text('banhammer:2', 'MOD')
        set_text('banhammer:3', '(#kick|spara|[sasha] uccidi) <id>|<username>|<reply>: Sasha rimuove l\'utente specificato.')
        set_text('banhammer:4', '(#ban|esplodi|kaboom|[sasha] banna|[sasha] decompila) <id>|<username>|<reply>: Sasha banna l\'utente specificato e lo rimuove, se tenta di rientrare viene nuovamente rimosso.')
        set_text('banhammer:5', '(#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>: Sasha sbanna l\'utente specificato.')
        set_text('banhammer:6', '(#banlist|[sasha] lista ban) [<group_id>]: Sasha mostra la lista di utenti bannati dal gruppo o da <group_id>.')
        set_text('banhammer:7', 'OWNER')
        set_text('banhammer:8', '(#kicknouser|[sasha] uccidi nouser|spara nouser): Sasha rimuove gli utenti senza username.')
        set_text('banhammer:9', '(#kickinactive [<msgs>]|((sasha uccidi)|spara sotto <msgs> messaggi)): Sasha rimuove tutti gli utenti inattivi sotto <msgs> messaggi.')
        set_text('banhammer:10', 'SUPPORT')
        set_text('banhammer:11', '(#gban|[sasha] superbanna) <id>|<username>|<reply>: Sasha superbanna l\'utente specificato e lo rimuove, se tenta di rientrare viene nuovamente rimosso.')
        set_text('banhammer:12', '(#ungban|[sasha] supersbanna) <id>|<username>|<reply>: Sasha supersbanna l\'utente specificato.')
        set_text('banhammer:13', '(#gbanlist|[sasha] lista superban): Sasha mostra la lista di utenti super bannati.')

        -- bot.lua --
        set_text('bot:0', 2)
        set_text('bot:1', 'OWNER')
        set_text('bot:2', '#bot|sasha on|off: Sasha si attiva|disattiva.')

        -- broadcast.lua --
        set_text('broadcast:0', 4)
        set_text('broadcast:1', 'ADMIN')
        set_text('broadcast:2', '#br <group_id> <text>: Sasha invia <text> a <group_id>.')
        set_text('broadcast:3', 'SUDO')
        set_text('broadcast:4', '#broadcast <text>: Sasha invia <text> a tutti i gruppi.')

        -- dogify.lua --
        set_text('dogify:0', 1)
        set_text('dogify:1', '(#dogify|[sasha] doge) <your/words/with/slashes>: Sasha crea un\'immagine col doge e le parole specificate.')

        -- duckduckgo.lua --
        set_text('duckduckgo:0', 1)
        set_text('duckduckgo:1', '#duck[duck]go <terms>: Sasha cerca <terms> su DuckDuckGo.')

        -- echo.lua --
        set_text('echo:0', 2)
        set_text('echo:1', 'MOD')
        set_text('echo:2', '(#echo|sasha ripeti) <text>: Sasha ripete <text>.')

        -- feedback.lua --
        set_text('feedback:0', 1)
        set_text('feedback:1', '#feedback <text>: Sasha invia <text> al suo creatore.')

        -- filemanager.lua --
        set_text('filemanager:0', 15)
        set_text('filemanager:1', 'SUDO')
        set_text('filemanager:2', '#folder: Sasha manda la directory attuale.')
        set_text('filemanager:3', '#cd [<directory>]: Sasha entra in <directory>, se non è specificata torna alla cartella base.')
        set_text('filemanager:4', '#ls: Sasha manda la lista di file e cartelle della directory corrente.')
        set_text('filemanager:5', '#mkdir <directory>: Sasha crea <directory>.')
        set_text('filemanager:6', '#rmdir <directory>: Sasha elimina <directory>.')
        set_text('filemanager:7', '#rm <file>: Sasha elimina <file>.')
        set_text('filemanager:8', '#touch <file>: Sasha crea <file>.')
        set_text('filemanager:9', '#cat <file>: Sasha manda il contenuto di <file>.')
        set_text('filemanager:10', '#tofile <file> <text>: Sasha crea <file> con <text> come contenuto.')
        set_text('filemanager:11', '#shell <command>: Sasha esegue <command>.')
        set_text('filemanager:12', '#cp <file> <directory>: Sasha copia <file> in <directory>.')
        set_text('filemanager:13', '#mv <file> <directory>: Sasha sposta <file> in <directory>.')
        set_text('filemanager:14', '#upload <file>: Sasha manda <file> nella chat.')
        set_text('filemanager:15', '#download <reply>: Sasha scarica il file contenuto in <reply>.')

        -- flame.lua --
        set_text('flame:0', 4)
        set_text('flame:1', 'MOD')
        set_text('flame:2', '(#startflame|[sasha] flamma) <id>|<username>|<reply>: Sasha flamma l\'utente specificato.')
        set_text('flame:3', '(#stopflame|[sasha] stop flame): Sasha smette di flammare.')
        set_text('flame:4', '(#flameinfo|[sasha] info flame): Sasha manda le info su chi sta flammando.')

        -- get.lua --
        set_text('get:0', 1)
        set_text('get:1', '(#getlist|#get|sasha lista): Sasha mostra una lista delle variabili settate.')
        set_text('get:2', '[#get] <var_name>: Sasha manda il valore di <var_name>.')

        -- google.lua --
        set_text('google:0', 2)
        set_text('google:1', '(#google|[sasha] googla) <terms>: Sasha cerca <terms> su Google e manda i risultati.')

        -- help.lua --
        set_text('help:0', 5)
        set_text('help:1', '(#sudolist|sasha lista sudo): Sasha manda la lista dei sudo.')
        set_text('help:2', '(#help|sasha aiuto): Sasha mostra una lista dei plugin disponibili.')
        set_text('help:3', '(#help|commands|sasha aiuto) <plugin_name>|<plugin_number> [<fake_rank>]: Sasha mostra l\'aiuto per il plugin specificato.')
        set_text('help:4', '(#helpall|allcommands|sasha aiuto tutto) [<fake_rank>]: Sasha mostra tutti i comandi di tutti i plugin.')
        set_text('help:5', 'Il parametro <fake_rank> serve per mandare l\'help di un rango più basso, i ranghi sono: USER, MOD, OWNER, SUPPORT, ADMIN, SUDO.')

        -- info.lua --
        set_text('info:0', 10)
        set_text('info:1', '#getrank|rango [<id>|<username>|<reply>]: Sasha manda il rank dell\'utente.')
        set_text('info:2', '(#info|[sasha] info): Sasha manda le info dell\'utente e della chat o di se stessa')
        set_text('info:3', 'MOD')
        set_text('info:4', '(#info|[sasha] info) <id>|<username>|<reply>|from: Sasha manda le info dell\'utente specificato.')
        set_text('info:5', '(#who|#members|[sasha] lista membri): Sasha manda la lista degli utenti.')
        set_text('info:6', '(#kicked|[sasha] lista rimossi): Sasha manda la lista degli utenti rimossi.')
        set_text('info:7', 'OWNER')
        set_text('info:8', '(#groupinfo|[sasha] info gruppo) [<group_id>]: Sasha manda le info del gruppo specificato.')
        set_text('info:9', 'SUDO')
        set_text('info:10', '(#database|[sasha] database): Sasha salva i dati di tutti gli utenti.')

        -- ingroup.lua --
        set_text('ingroup:0', 32)
        set_text('ingroup:1', '(#rules|sasha regole): Sasha mostra le regole del gruppo.')
        set_text('ingroup:2', '(#about|sasha descrizione): Sasha mostra la descrizione del gruppo.')
        set_text('ingroup:3', '(#modlist|[sasha] lista mod): Sasha mostra la lista dei moderatori.')
        set_text('ingroup:4', '#owner: Sasha mostra l\'id del proprietario del gruppo.')
        set_text('ingroup:5', 'MOD')
        set_text('ingroup:6', '#setname|#setgpname <group_name>: Sasha imposta il nome del gruppo con <group_name>.')
        set_text('ingroup:7', '#setphoto|#setgpphoto: Sasha imposta e blocca la foto del gruppo.')
        set_text('ingroup:8', '(#setrules|sasha imposta regole) <text>: Sasha imposta <text> come regole.')
        set_text('ingroup:9', '(#setabout|sasha imposta descrizione) <text>: Sasha imposta <text> come descrizione.')
        set_text('ingroup:10', '(#lock|[sasha] blocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha blocca l\'opzione specificata.')
        set_text('ingroup:11', '(#unlock|[sasha] sblocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha sblocca l\'opzione specificata.')
        set_text('ingroup:12', '#muteuser|voce <id>|<username>|<reply>: Sasha imposta|toglie il muto sull\'utente.')
        set_text('ingroup:13', '(#muteslist|lista muti): Sasha manda la lista delle variabili mute della chat.')
        set_text('ingroup:14', '(#mutelist|lista utenti muti): Sasha manda la lista degli utenti muti della chat.')
        set_text('ingroup:15', '#settings: Sasha mostra le impostazioni del gruppo.')
        set_text('ingroup:16', '#public yes|no: Sasha imposta il gruppo come pubblico|privato.')
        set_text('ingroup:17', '(#newlink|sasha crea link): Sasha crea il link del gruppo.')
        set_text('ingroup:18', '(#link|sasha link): Sasha mostra il link del gruppo.')
        set_text('ingroup:19', '#setflood <value>: Sasha imposta il flood massimo del gruppo a <value>.')
        set_text('ingroup:20', 'OWNER')
        set_text('ingroup:21', '(#setlink|[sasha] imposta link): Sasha imposta il link d\'invito con quello che le verrà inviato.')
        set_text('ingroup:22', '(#promote|[sasha] promuovi) <username>|<reply>: Sasha promuove a moderatore l\'utente specificato.')
        set_text('ingroup:23', '(#demote|[sasha] degrada) <username>|<reply>: Sasha degrada l\'utente specificato.')
        set_text('ingroup:24', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha imposta il muto sulla variabile specificata.')
        set_text('ingroup:25', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha rimuove il muto sulla variabile specificata.')
        set_text('ingroup:26', '#setowner <id>: Sasha imposta <id> come proprietario.')
        set_text('ingroup:27', '#clean modlist|rules|about: Sasha pulisce il parametro specificato.')
        set_text('ingroup:28', 'ADMIN')
        set_text('ingroup:29', '#add [realm]: Sasha aggiunge il gruppo|regno.')
        set_text('ingroup:30', '#rem [realm]: Sasha rimuove il gruppo|regno.')
        set_text('ingroup:31', '#kill chat|realm: Sasha elimina ogni utente nel gruppo|regno e poi lo chiude.')
        set_text('ingroup:32', '#setgpowner <group_id> <user_id>: Sasha imposta <user_id> come proprietario.')

        -- inpm.lua --
        set_text('inpm:0', 10)
        set_text('inpm:1', '#chats: Sasha mostra un elenco di chat "pubbliche".')
        set_text('inpm:2', '#chatlist: Sasha manda un file con un elenco di chat "pubbliche".')
        set_text('inpm:3', 'ADMIN')
        set_text('inpm:4', '#join <chat_id>|<alias> [support]: Sasha tenta di aggiungere l\'utente a <chat_id>|<alias>.')
        set_text('inpm:5', '#getaliaslist: Sasha manda la lista degli alias.')
        set_text('inpm:6', 'SUDO')
        set_text('inpm:7', '#allchats: Sasha mostra l\'elenco delle chat.')
        set_text('inpm:8', '#allchatlist: Sasha manda un file con l\'elenco delle chat.')
        set_text('inpm:9', '#setalias <alias> <group_id>: Sasha imposta <alias> come alias di <group_id>.')
        set_text('inpm:10', '#unsetalias <alias>: Sasha elimina <alias>.')

        -- inrealm.lua --
        set_text('inrealm:0', 26)
        set_text('inrealm:1', 'MOD')
        set_text('inrealm:2', '#who: Sasha mostra una lista di membri del gruppo/regno.')
        set_text('inrealm:3', '#wholist: Sasha invia un file con una lista di membri del gruppo/regno.')
        set_text('inrealm:4', 'OWNER')
        set_text('inrealm:5', '#log: Sasha manda un file contenente il log del gruppo/regno.')
        set_text('inrealm:6', 'ADMIN')
        set_text('inrealm:7', '(#creategroup|sasha crea gruppo) <group_name>: Sasha crea un gruppo col nome specificato.')
        set_text('inrealm:8', '(#createsuper|sasha crea supergruppo) <group_name>: Sasha crea un supergruppo col nome specificato.')
        set_text('inrealm:9', '(#createrealm|sasha crea regno) <realm_name>: Sasha crea un regno col nome specificato.')
        set_text('inrealm:10', '(#setabout|sasha imposta descrizione) <group_id> <text>: Sasha cambia la descrizione di <group_id> in <text>.')
        set_text('inrealm:11', '(#setrules|sasha imposta regole) <group_id> <text>: Sasha cambia le regole di <group_id> in <text>.')
        set_text('inrealm:12', '#setname <realm_name>: Sasha cambia il nome del regno in <realm_name>.')
        set_text('inrealm:13', '#setname|#setgpname <group_id> <group_name>: Sasha cambia il nome di <group_id> in <group_name>.')
        set_text('inrealm:14', '(#lock|[sasha] blocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha blocca l\'impostazione specificata di <group_id>.')
        set_text('inrealm:15', '(#unlock|[sasha] sblocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha sblocca l\'impostazione specificata di <group_id>.')
        set_text('inrealm:16', '#settings <group_id>: Sasha manda le impostazioni di <group_id>.')
        set_text('inrealm:17', '#type: Sasha mostra il tipo del gruppo.')
        set_text('inrealm:18', '#kill chat <group_id>: Sasha rimuove tutti i membri di <group_id> e <group_id>.')
        set_text('inrealm:19', '#kill realm <realm_id>: Sasha rimuove tutti i membri di <realm_id> e <realm_id>.')
        set_text('inrealm:20', '#rem <group_id>: Sasha rimuove il gruppo.')
        set_text('inrealm:21', '#support <user_id>|<username>: Sasha promuove l\'utente specificato a supporto.')
        set_text('inrealm:22', '#-support <user_id>|<username>: Sasha degrada l\'utente specificato.')
        set_text('inrealm:23', '#list admins|groups|realms: Sasha mostra una lista della variabile specificata.')
        set_text('inrealm:24', 'SUDO')
        set_text('inrealm:25', '#addadmin <user_id>|<username>: Sasha promuove l\'utente specificato ad amminstratore.')
        set_text('inrealm:26', '#removeadmin <user_id>|<username>: Sasha degrada l\'utente specificato.')

        -- interact.lua --
        set_text('interact:0', 1)
        set_text('interact:1', 'Sasha interagisce con gli utenti.')

        -- invite.lua --
        set_text('invite:0', 2)
        -- set_text('invite:1','OWNER')
        set_text('invite:1', 'ADMIN')
        set_text('invite:2', '(#invite|[sasha] invita|[sasha] resuscita) <id>|<username>|<reply>: Sasha invita l\'utente specificato.')

        -- leave_ban.lua --
        set_text('leave_ban:0', 1)
        set_text('leave_ban:1', 'Sasha banna l\'utente che esce dal gruppo.')

        -- msg_checks.lua --
        set_text('msg_checks:0', 1)
        set_text('msg_checks:1', 'Sasha controlla i messaggi che riceve.')

        -- onservice.lua --
        set_text('onservice:0', 2)
        set_text('onservice:1', 'ADMIN')
        set_text('onservice:2', '(#leave|sasha abbandona): Sasha lascia il gruppo.')

        -- owners.lua --
        set_text('owners:0', 5)
        -- set_text('owners:1','#owners <group_id>: Sasha invia il log di <group_id>.')
        set_text('owners:1', '#changeabout <group_id> <text>: Sasha cambia la descrizione di <group_id> con <text>.')
        set_text('owners:2', '#changerules <group_id> <text>: Sasha cambia le regole di <group_id> con <text>.')
        set_text('owners:3', '#changename <group_id> <text>: Sasha cambia il nome di <group_id> con <text>.')
        set_text('owners:4', '#viewsettings <group_id>: Sasha manda le impostazioni di <group_id>.')
        set_text('owners:5', '#loggroup <group_id>: Sasha invia il log di <group_id>.')

        -- plugins.lua --
        set_text('plugins:0', 9)
        set_text('plugins:1', 'OWNER')
        set_text('plugins:2', '(#disabledlist|([sasha] lista disabilitati|disattivati)): Sasha mostra una lista dei plugins disabilitati su questa chat.')
        set_text('plugins:3', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> chat: Sasha riabilita <plugin> su questa chat.')
        set_text('plugins:4', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> chat: Sasha disabilita <plugin> su questa chat.')
        set_text('plugins:5', 'SUDO')
        set_text('plugins:6', '(#plugins|[sasha] lista plugins): Sasha mostra una lista di tutti i plugins.')
        set_text('plugins:7', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> [chat]: Sasha abilita <plugin>, se specificato solo su questa chat.')
        set_text('plugins:8', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> [chat]: Sasha disabilita <plugin>, se specificato solo su questa chat.')
        set_text('plugins:9', '(#[plugin[s]] reload|[sasha] ricarica): Sasha ricarica tutti i plugins.')

        -- pokedex.lua --
        set_text('pokedex:0', 1)
        set_text('pokedex:1', '#pokedex|#pokemon <name>|<id>: Sasha cerca il pokémon specificato e ne invia le informazioni.')

        -- qr.lua --
        set_text('qr:0', 5)
        set_text('qr:1', '(#qr|sasha qr) ["<background_color>" "<data_color>"] <text>: Sasha crea il QR Code di <text>, se specificato colora il QR Code.')
        set_text('qr:2', 'I colori possono essere specificati come segue:')
        set_text('qr:3', 'Testo => red|green|blue|purple|black|white|gray.')
        set_text('qr:4', 'Notazione Esadecimale => ("a56729" è marrone).')
        set_text('qr:5', 'Notazione Decimale => ("255-192-203" è rosa).')

        -- reactions.lua --
        set_text('reactions:0', 2)
        set_text('reactions:1', 'SUDO')
        set_text('reactions:2', '#writing on|off: Sasha (fa finta|smette di far finta) di scrivere.')

        -- ruleta.lua --
        set_text('ruleta:0', 24)
        set_text('ruleta:1', 'Ruleta by AISasha, inspired from Leia (#RIP) and Arya. Ruleta è la roulette russa con la pistola, tamburo da tot colpi con tot proiettili al suo interno, si gira il tamburo e se c\'è il proiettile sei fuori altrimenti rimani.')
        set_text('ruleta:2', '#registerme|#registrami: Sasha registra l\'utente alla roulette.')
        set_text('ruleta:3', '#deleteme|#eliminami: Sasha elimina i dati dell\'utente.')
        set_text('ruleta:4', '#ruletainfo: Sasha manda le informazioni della roulette.')
        set_text('ruleta:5', '#mystats|#punti: Sasha manda le statistiche dell\'utente.')
        set_text('ruleta:6', '#ruleta: Sasha cerca di ucciderti.')
        set_text('ruleta:7', '#godruleta: Sasha ti dà il 50% di probabilità di guadagnare 70 punti, con l\'altro 50% li perdi tutti (richiede almeno 11 punti).')
        set_text('ruleta:8', '#challenge|#sfida <username>|<reply>: Sasha avvia una sfida tra il mittente e l\'utente specificato.')
        set_text('ruleta:9', '#accept|#accetta: Sasha conferma la sfida.')
        set_text('ruleta:10', '#reject|#rifiuta: Sasha cancella la sfida.')
        set_text('ruleta:11', '#challengeinfo: Sasha manda le informazioni della sfida in corso.')
        set_text('ruleta:12', 'MOD')
        set_text('ruleta:13', '#setcaps <value>: Sasha mette <value> proiettili nel tamburo.')
        set_text('ruleta:14', '#setchallengecaps <value>: Sasha mette <value> proiettili nel tamburo delle sfide.')
        set_text('ruleta:15', '(#kick|spara|[sasha] uccidi) random: Sasha sceglie un utente a caso e lo rimuove.')
        set_text('ruleta:16', 'OWNER')
        set_text('ruleta:17', '#setcylinder <value>: Sasha imposta un tamburo da <value> colpi nel range [5-10].')
        set_text('ruleta:18', '#setchallengecylinder <value>: Sasha imposta un tamburo da <value> colpi per le sfide nel range [5-10].')
        set_text('ruleta:19', 'ADMIN')
        set_text('ruleta:20', '#registergroup|#registragruppo: Sasha abilita il gruppo a giocare a ruleta.')
        set_text('ruleta:21', '#deletegroup|#eliminagruppo: Sasha disabilita il gruppo per ruleta.')
        set_text('ruleta:22', 'SUDO')
        set_text('ruleta:23', '#createdb: Sasha crea il database di ruleta.')
        set_text('ruleta:24', '#addpoints <id> <value>: Sasha aggiunge <value> punti all\'utente specificato.')

        -- set.lua --
        set_text('set:0', 4)
        set_text('set:1', 'MOD')
        set_text('set:2', '(#set|[sasha] setta) <var_name> <text>: Sasha salva <text> come risposta a <var_name>.')
        set_text('set:3', '(#setmedia|[sasha] setta media) <var_name>: Sasha salva il media (foto o audio) che le verrà inviato come risposta a <var_name>.')
        set_text('set:4', '(#cancel|[sasha] annulla): Sasha annulla un #setmedia.')

        -- shout.lua --
        set_text('shout:0', 2)
        set_text('shout:1', '(#shout|[sasha] grida|[sasha] urla) <text>: Sasha "urla" <text>.')

        -- spam.lua --
        set_text('spam:0', 5)
        set_text('spam:1', 'OWNER')
        set_text('spam:2', '#setspam <text>: Sasha imposta <text> come messaggio da spammare.')
        set_text('spam:3', '#setmsgs <value>: Sasha imposta <value> come numero di messaggi da spammare.')
        set_text('spam:4', '#setwait <seconds>: Sasha imposta <seconds> come intervallo di tempo tra i messaggi.')
        set_text('spam:5', '(#spam|[sasha] spamma): Sasha inizia a spammare.')

        -- stats.lua --
        set_text('stats:0', 8)
        set_text('stats:1', '[#]aisasha: Sasha invia la propria descrizione.')
        set_text('stats:2', 'MOD')
        set_text('stats:3', '(#stats|#messages): Sasha invia le statistiche della chat.')
        set_text('stats:4', '(#statslist|#messageslist): Sasha invia un file con le statistiche della chat.')
        set_text('stats:5', 'ADMIN')
        set_text('stats:6', '(#stats|#messages) group <group_id>: Sasha invia le statistiche relative al gruppo specificato.')
        set_text('stats:7', '(#statslist|#messageslist) group <group_id>: Sasha invia un file con le statistiche relative al gruppo specificato.')
        set_text('stats:8', '(#stats|#messages) aisasha: Sasha invia le proprie statistiche.')

        -- strings_en.lua --
        set_text('strings_en:0', 2)
        set_text('strings_en:1', 'SUDO')
        set_text('strings_en:2', '(#updateenstrings|#installenstrings|([sasha] installa|[sasha] aggiorna) stringhe en): Sasha updates strings.')

        -- strings_it.lua --
        set_text('strings_it:0', 2)
        set_text('strings_it:1', 'SUDO')
        set_text('strings_it:2', '(#updateitstrings|#installitstrings|([sasha] installa|[sasha] aggiorna) stringhe it): Sasha aggiorna le stringhe di testo.')

        -- supergroup.lua --
        set_text('supergroup:0', 45)
        set_text('supergroup:1', '#owner: Sasha manda il proprietario.')
        set_text('supergroup:2', '(#modlist|[sasha] lista mod): Sasha manda la lista dei moderatori.')
        set_text('supergroup:3', '(#rules|sasha regole): Sasha manda le regole del gruppo.')
        set_text('supergroup:4', 'MOD')
        set_text('supergroup:5', '(#bots|[sasha] lista bot): Sasha manda la lista dei bot.')
        set_text('supergroup:6', '#wholist|#memberslist: Sasha manda un file contenente la lista degli utenti.')
        set_text('supergroup:7', '#kickedlist: Sasha manda la lista degli utenti rimossi.')
        set_text('supergroup:8', '#del <reply>: Sasha elimina il messaggio specificato.')
        set_text('supergroup:9', '(#newlink|[sasha] crea link): Sasha crea un nuovo link d\'invito.')
        set_text('supergroup:10', '(#link|sasha link): Sasha manda il link d\'invito.')
        set_text('supergroup:11', '#setname|setgpname <text>: Sasha cambia il nome del gruppo con <text>.')
        set_text('supergroup:12', '#setphoto|setgpphoto: Sasha cambia la foto del gruppo.')
        set_text('supergroup:13', '(#setrules|sasha imposta regole) <text>: Sasha cambia le regole del gruppo con <text>.')
        set_text('supergroup:14', '(#setabout|sasha imposta descrizione) <text>: Sasha cambia la descrizione del gruppo con <text>.')
        set_text('supergroup:15', '(#lock|[sasha] blocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha blocca l\'opzione specificata.')
        set_text('supergroup:16', '(#unlock|[sasha] sblocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha sblocca l\'opzione specificata.')
        set_text('supergroup:17', '#setflood <value>: Sasha imposta il flood massimo a <value> che deve essere compreso tra 5 e 20.')
        set_text('supergroup:18', '#public yes|no: Sasha imposta il gruppo come pubblico|privato.')
        set_text('supergroup:19', '#muteuser|voce <id>|<username>|<reply>: Sasha imposta|toglie il muto sull\'utente.')
        set_text('supergroup:20', '(#muteslist|lista muti): Sasha manda la lista delle variabili mute della chat.')
        set_text('supergroup:21', '(#mutelist|lista utenti muti): Sasha manda la lista degli utenti muti della chat.')
        set_text('supergroup:22', '#settings: Sasha manda le impostazioni del gruppo.')
        set_text('supergroup:23', 'OWNER')
        set_text('supergroup:24', '(#admins|[sasha] lista admin): Sasha manda la lista degli amministratori.')
        set_text('supergroup:25', '(#setlink|sasha imposta link): Sasha imposta il link d\'invito con quello che le verrà inviato.')
        set_text('supergroup:26', '#setadmin <id>|<username>|<reply>: Sasha promuove l\'utente specificato ad amministratore (telegram).')
        set_text('supergroup:27', '#demoteadmin <id>|<username>|<reply>: Sasha degrada l\'utente specificato (telegram).')
        set_text('supergroup:28', '#setowner <id>|<username>|<reply>: Sasha imposta l\'utente specificato come proprietario.')
        set_text('supergroup:29', '(#promote|[sasha] promuovi) <id>|<username>|<reply>: Sasha promuove l\'utente specificato a moderatore.')
        set_text('supergroup:30', '(#demote|[sasha] degrada) <id>|<username>|<reply>: Sasha degrada l\'utente specificato.')
        set_text('supergroup:31', '#clean rules|about|modlist|mutelist: Sasha azzera la variabile specificata.')
        set_text('supergroup:32', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha imposta il muto sulla variabile specificata.')
        set_text('supergroup:33', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha rimuove il muto sulla variabile specificata.')
        set_text('supergroup:34', 'SUPPORT')
        set_text('supergroup:35', '#add: Sasha aggiunge il supergruppo.')
        set_text('supergroup:36', '#rem: Sasha rimuove il supergruppo.')
        set_text('supergroup:37', 'ADMIN')
        set_text('supergroup:38', '#tosuper: Sasha aggiorna il gruppo a supergruppo.')
        set_text('supergroup:39', '#setusername <text>: Sasha cambia l\'username del gruppo con <text>.')
        set_text('supergroup:40', 'peer_id')
        set_text('supergroup:41', 'msg.to.id')
        set_text('supergroup:42', 'msg.to.peer_id')
        set_text('supergroup:43', 'SUDO')
        set_text('supergroup:44', '#mp <id>: Sasha promuove <id> a moderatore del gruppo (telegram).')
        set_text('supergroup:45', '#md <id>: Sasha degrada <id> dal ruolo di moderatore del gruppo (telegram).')

        -- tagall.lua --
        set_text('tagall:0', 2)
        set_text('tagall:1', 'OWNER')
        set_text('tagall:2', '(#tagall|sasha tagga tutti) <text>: Sasha tagga tutti i membri del gruppo con username e scrive <text>.')

        -- tex.lua --
        set_text('tex:0', 1)
        set_text('tex:1', '(#tex|[sasha] equazione) <equation>: Sasha converte <equation> in immagine.')

        -- unset.lua --
        set_text('unset:0', 2)
        set_text('unset:1', 'MOD')
        set_text('unset:2', '(#unset|[sasha] unsetta) <var_name>: Sasha elimina <var_name>.')

        -- urbandictionary.lua --
        set_text('urbandictionary:0', 1)
        set_text('urbandictionary:1', '(#urbandictionary|#urban|#ud|[sasha] urban|[sasha] ud) <text>: Sasha mostra la definizione di <text> dall\'Urban Dictionary.')

        -- warn.lua --
        set_text('warn:0', 7)
        set_text('warn:1', 'MOD')
        set_text('warn:2', '#setwarn <value>: Sasha imposta gli avvertimenti massimi a <value>, se zero gli avvertimenti non funzioneranno più.')
        set_text('warn:3', '#getwarn: Sasha manda il numero di avvertimenti massimi.')
        set_text('warn:4', '(#getuserwarns|[sasha] ottieni avvertimenti) <id>|<username>|<reply>: Sasha manda il numero di avvertimenti ricevuti dall\'utente.')
        set_text('warn:5', '(#warn|[sasha] avverti) <id>|<username>|<reply>: Sasha avverte l\'utente.')
        set_text('warn:6', '#unwarn <id>|<username>|<reply>: Sasha diminuisce di uno gli avvertimenti dell\'utente.')
        set_text('warn:7', '(#unwarnall|[sasha] azzera avvertimenti) <id>|<username>|<reply>: Sasha azzera gli avvertimenti dell\'utente.')

        -- webshot.lua --
        set_text('webshot:0', 14)
        set_text('webshot:1', 'MOD')
        set_text('webshot:2', '(#webshot|[sasha] webshotta) <url> [<size>]: Sasha esegue uno screenshot di <url> e lo invia, se <size> è specificata di quella dimensione.')
        set_text('webshot:3', 'La dimensione può essere:')
        set_text('webshot:4', 'T: (120 x 90px)')
        set_text('webshot:5', 'S: (200 x 150px)')
        set_text('webshot:6', 'E: (320 x 240px)')
        set_text('webshot:7', 'N: (400 x 300px)')
        set_text('webshot:8', 'M: (640 x 480px)')
        set_text('webshot:9', 'L: (800 x 600px)')
        set_text('webshot:10', 'X: (1024 x 768px)')
        set_text('webshot:11', 'Nmob: (480 x 800px)')
        set_text('webshot:12', 'ADMIN')
        set_text('webshot:13', 'F: Pagina intera (può essere un processo molto lungo)')
        set_text('webshot:14', 'Fmob: Pagina intera (può essere un processo lungo)')

        -- welcome.lua --
        set_text('welcome:0', 5)
        set_text('welcome:1', '#getwelcome: Sasha manda il benvenuto.')
        set_text('welcome:2', 'OWNER')
        set_text('welcome:3', '#setwelcome <text>: Sasha imposta <text> come benvenuto.')
        set_text('welcome:4', '#setmemberswelcome <value>: Sasha dopo <value> membri manderà il benvenuto con le regole, se zero il benvenuto non verrà più mandato.')
        set_text('welcome:5', '#getmemberswelcome: Sasha manda il numero di membri entrati dopo i quali invia il benvenuto.')

        -- whitelist.lua --
        set_text('whitelist:0', 3)
        set_text('whitelist:1', 'ADMIN')
        set_text('whitelist:2', '#whitelist <id>|<username>|<reply>: Sasha aggiunge|rimuove l\'utente specificato alla|dalla whitelist.')
        set_text('whitelist:3', '#clean whitelist: Sasha pulisce la whitelist.')

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