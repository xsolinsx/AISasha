--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------

local LANG = 'EN'

local function run(msg, matches)
    if is_sudo(msg) then
        -------------
        -- Plugins --
        -------------

        -- global --
        set_text('require_sudo', '🚫 This plugin requires sudo privileges.')
        set_text('require_admin', '🚫 This plugin requires admin privileges or higher.')
        set_text('require_owner', '🚫 This plugin requires owner privileges or higher.')
        set_text('require_mod', '🚫 This plugin requires mod privileges or higher.')
        set_text('errorTryAgain', 'Error, try again.')
        set_text('opsError', 'Ops, error.')
        set_text('useYourGroups', 'Use it in your groups!')
        set_text('cantKickHigher', 'You can\'t remove mod/owner/admin/sudo!')
        set_text('user', 'User ')
        set_text('kicked', ' kicked.')
        set_text('banned', ' banned.')
        set_text('unbanned', ' unbanned.')
        set_text('gbanned', ' globally banned.')
        set_text('ungbanned', ' globally unbanned.')

        -- seedbot.lua --
        set_text('sender', 'Sender: ')
        set_text('receiver', 'Receiver: ')
        set_text('msgText', 'Message: ')

        -- utils.lua --
        set_text('errorImageDownload', 'Error downloading the picture.')
        set_text('banListStart', 'Banlist:\n\n')
        set_text('gbanListStart', 'GBanlist:\n\n')
        set_text('mutedUsersStart', 'Muted users of:')
        set_text('mutedTypesStart', 'Mutes of:')
        set_text('mute', 'Mute ')
        set_text('alreadyEnabled', ' already enabled.')
        set_text('enabled', ' enabled.')
        set_text('alreadyDisabled', ' already disabled.')
        set_text('disabled', ' disabled')
        set_text('noAutoKick', 'You can\'t kick yourself.')
        set_text('noAutoBan', 'You can\'t ban yourself.')

        -- admin.lua --
        set_text('sendNewPic', 'Send me the new picture.')
        set_text('botPicChanged', 'Picture changed!')
        set_text('logSet', 'Log added.')
        set_text('logUnset', 'Log removed.')
        set_text('markRead', 'Mark read')
        set_text('pmSent', 'Message sent')
        set_text('cantBlockAdmin', 'You can\'t block admins.')
        set_text('userBlocked', 'User blocked.')
        set_text('userUnblocked', 'User unblocked.')
        set_text('contactListSent', 'I\'ve sent you the contactlist in the requested format.')
        set_text('removedFromContacts', ' removed from contacts.')
        set_text('addedToContacts', ' added to contacts.')
        set_text('contactMissing', 'I haven\'t got your phone number!')
        set_text('chatListSent', 'I\'ve sent you the dialoglist in the requested format.')
        set_text('gbansSync', 'GBanlist sync completed.')
        set_text('longidUpdate', 'Update long_ID.')
        set_text('alreadyLog', 'Already a log group.')
        set_text('notLog', 'Not a log group.')
        set_text('backupDone', 'Backup finished, I\'m sending you the log.')

        -- anti_spam.lua --
        set_text('blockedForSpam', ' blocked (SPAM).')
        set_text('floodNotAdmitted', 'Flooding is not admitted.\n')
        set_text('statusRemoved', 'User kicked.')
        set_text('gbannedFrom', ' globally banned from ')

        -- arabic_lock.lua --
        set_text('arabicNotAllowed', 'Arabic/Persian is not admitted.\n')
        set_text('statusRemovedMsgDeleted', 'User kicked/Message deleted.')

        -- banhammer.lua --
        set_text('noUsernameFound', 'Can\'t find a user with that username.')

        -- bot.lua --
        set_text('botOn', 'I\'m back. 😏')
        set_text('botOff', 'Nothing to do here. 🚀')

        -- feedback.lua --
        set_text('feedStart', '@EricSolinas you received a feedback: #newfeedback\n\nSender')
        set_text('feedName', '\nName: ')
        set_text('feedSurname', '\nSurname: ')
        set_text('feedUsername', '\nUsername: @')
        set_text('feedSent', 'Feedback sent!')

        -- filemanager.lua --
        set_text('backHomeFolder', 'You\'re in the base folder: ')
        set_text('youAreHere', 'You are here: ')
        set_text('folderCreated', 'Folder \'X\' created.')
        set_text('folderDeleted', 'Folder \'X\' deleted.')
        set_text('fileCreatedWithContent', ' created with \'X\' as contents.')
        set_text('copiedTo', ' copied to ')
        set_text('movedTo', ' moved to ')
        set_text('sendingYou', 'I\'m sending ')
        set_text('useQuoteOnFile', 'Use \'reply\' on the file you want me to download.')
        set_text('needMedia', 'I need a file.')
        set_text('mediaNotRecognized', 'File not recognized.')
        set_text('fileDownloadedTo', 'File downloaded to: ')
        set_text('errorDownloading', 'Error downloading: ')

        -- flame.lua --
        set_text('cantFlameHigher', 'You can\'t flame mod/owner/admin/sudo/!')
        set_text('noAutoFlame', 'I can\'t flame myself you jerk!')
        set_text('hereIAm', 'Here I am!')
        set_text('stopFlame', 'Yeah I\'m done, holy shit.')
        set_text('flaming', 'I\'m flaming: ')
        set_text('errorParameter', 'Redis variable missing.')

        -- help.lua --
        set_text('require_higher', '🚫 This plugin requires higher privileges.\n')
        set_text('pluginListStart', 'ℹ️Plugins list: \n\n')
        set_text('helpInfo', 'ℹ️Write "!help <plugin_name>|<plugin_number>" for more info on that plugin.\nℹ️Or "!helpall" to have all commands.')
        set_text('errorNoPlugin', 'This plugin doesn\'t exist or doesn\'t have a description.')
        set_text('doYourBusiness', 'Do your business!')
        set_text('helpIntro', 'Every \'#\' can be replaced with \'/\' or \'!\'.\nAll commands are Case Insensitive.\nSquare brackets means that is an optional.\nRound brackets with \'|\' means that\'s a choice".\n\n')

        -- groups --
        set_text('newDescription', 'New description:\n')
        set_text('noDescription', 'No description available.')
        set_text('description', 'Chat description: ')
        set_text('newRules', 'New rules:\n')
        set_text('noRules', 'No rules available.')
        set_text('rules', 'Chat rules: ')
        set_text('sendNewGroupPic', 'Send the new group picture.')
        set_text('photoSaved', 'Picture saved.')
        set_text('groupSettings', 'Group settings: ')
        set_text('supergroupSettings', 'Supergroup settings: ')
        set_text('noGroups', 'No groups at the moment.')
        set_text('errorFloodRange', 'Error, range is [3-200]')
        set_text('floodSet', 'Flood set to ')
        set_text('noOwnerCallAdmin', 'No owner, contact an admin to set one.')
        set_text('ownerIs', 'Group owner is ')
        set_text('errorCreateLink', 'Error, can\'t create link.\nI\'m not the owner.')
        set_text('errorCreateSuperLink', 'Error, can\'t create link.\nI\'m not the owner.\n\nIf you have the link use /setlink to set it')
        set_text('createLinkInfo', 'Create a link using /newlink.')
        set_text('linkCreated', 'New link created.')
        set_text('groupLink', 'Link\n')
        set_text('adminListStart', 'Admins:\n')
        set_text('alreadyMod', ' is already a mod.')
        set_text('promoteMod', ' has been promoted to mod.')
        set_text('notMod', ' is not a mod.')
        set_text('demoteMod', ' has been demoted from mod.')
        set_text('noGroupMods', 'No mod in this group.')
        set_text('modListStart', 'Mods of ')
        set_text('muteUserAdd', ' added to muted users list.')
        set_text('muteUserRemove', ' removed from muted users list.')
        set_text('modlistCleaned', 'Mod list cleaned.')
        set_text('rulesCleaned', 'Rules cleaned.')
        set_text('descriptionCleaned', 'Description cleaned.')
        set_text('mutelistCleaned', 'Mute list cleaned.')

        -- info.lua --
        set_text('info', 'INFO')
        set_text('youAre', '\nYou are')
        set_text('name', '\nName: ')
        set_text('surname', '\nSurname: ')
        set_text('username', '\nUsername: ')
        set_text('phone', '\nPhone: ')
        set_text('date', '\nDate: ')
        set_text('youAreWriting', '\n\nYou are writing to')
        set_text('groupName', '\nGroup name: ')
        set_text('members', '\nMembers: ')
        set_text('supergroupName', '\nSupergroup name: ')
        set_text('infoFor', 'Info for: ')
        set_text('users', '\nUsers: ')
        set_text('admins', '\nAdmins: ')
        set_text('kickedUsers', '\nKicked users: ')
        set_text('userInfo', 'User info:')

        -- ingroup.lua --
        set_text('welcomeNewRealm', 'Welcome to your new realm.')
        set_text('realmIs', 'This is a realm.')
        set_text('realmAdded', 'Realm has been added.')
        set_text('realmAlreadyAdded', 'Realm is already added.')
        set_text('realmRemoved', 'Realm has been removed.')
        set_text('realmNotAdded', 'Realm not added.')
        set_text('errorAlreadyRealm', 'Error, already a realm.')
        set_text('errorNotRealm', 'Error, not a realm.')
        set_text('promotedOwner', 'You\'ve been promoted as owner.')
        set_text('groupIs', 'This is a group.')
        set_text('groupAlreadyAdded', 'Group is already added.')
        set_text('groupAddedOwner', 'Group has been added and you\'ve been promoted as owner.')
        set_text('groupRemoved', 'Group has been removed.')
        set_text('groupNotAdded', 'Group not added.')
        set_text('errorAlreadyGroup', 'Error, already a group.')
        set_text('errorNotGroup', 'Error, not a group.')
        set_text('noAutoDemote', 'You can\'t demote yourself.')

        -- inpm.lua --
        set_text('none', 'No one')
        set_text('groupsJoin', 'Groups:\nUse /join <group_id> to enter\n\n')
        set_text('youGbanned', 'You are globally banned.')
        set_text('youBanned', 'You are banned.')
        set_text('chatNotFound', 'Chat not found.')
        set_text('privateGroup', 'Private group.')
        set_text('addedTo', 'You\'ve been added to: ')
        set_text('supportAdded', 'Support added ')
        set_text('adminAdded', 'Admin added ')
        set_text('toChat', ' to 👥 ')

        -- inrealm.lua --
        set_text('realm', 'Realm ')
        set_text('group', 'Groups ')
        set_text('created', ' created.')
        set_text('chatTypeNotFound', 'Chat type not found.')
        set_text('usersIn', 'Users in ')
        set_text('alreadyAdmin', ' is already admin.')
        set_text('promoteAdmin', ' has been promoted to admin.')
        set_text('notAdmin', ' is not admin.')
        set_text('demoteAdmin', ' has been demoted from admin.')
        set_text('groupListStart', 'Groups:\n')
        set_text('noRealms', 'No realm at the moment.')
        set_text('realmListStart', 'Realms:\n')
        set_text('inGroup', ' in this group')
        set_text('supportRemoved', ' has been removed from support team.')
        set_text('supportAdded', ' has been added to support team.')
        set_text('logAlreadyYes', 'Log group already enabled.')
        set_text('logYes', 'Log group enabled.')
        set_text('logAlreadyNo', 'Log group already disabled.')
        set_text('logNo', 'Log group disabled.')
        set_text('descriptionSet', 'Description set for: ')
        set_text('errorGroup', 'Error, group ')
        set_text('errorRealm', 'Error, realm ')
        set_text('notFound', ' not found')
        set_text('chat', 'Chat ')
        set_text('removed', ' removed')
        set_text('groupListCreated', 'Group list created.')
        set_text('realmListCreated', 'Realm list created.')

        -- invite.lua --
        set_text('userBanned', 'User is banned.')
        set_text('userGbanned', 'User is globally banned.')
        set_text('privateGroup', 'Group is private.')

        -- locks --
        set_text('nameLock', '\nLock name: ')
        set_text('nameAlreadyLocked', 'Name already locked.')
        set_text('nameLocked', 'Name locked.')
        set_text('nameAlreadyUnlocked', 'Name already unlocked.')
        set_text('nameUnlocked', 'Name unlocked.')
        set_text('photoLock', '\nLock photo: ')
        set_text('photoAlreadyLocked', 'Photo already locked.')
        set_text('photoLocked', 'Photo locked.')
        set_text('photoAlreadyUnlocked', 'Photo already unlocked.')
        set_text('photoUnlocked', 'Photo unlocked.')
        set_text('membersLock', '\nLock members: ')
        set_text('membersAlreadyLocked', 'Members already locked.')
        set_text('membersLocked', 'Members locked.')
        set_text('membersAlreadyUnlocked', 'Members already unlocked.')
        set_text('membersUnlocked', 'Members unlocked.')
        set_text('leaveLock', '\nLock leave: ')
        set_text('leaveAlreadyLocked', 'Leave already locked.')
        set_text('leaveLocked', 'Leave locked.')
        set_text('leaveAlreadyUnlocked', 'Leave already unlocked.')
        set_text('leaveUnlocked', 'Leave unlocked.')
        set_text('spamLock', '\nLock spam: ')
        set_text('spamAlreadyLocked', 'Spam already locked.')
        set_text('spamLocked', 'Spam locked.')
        set_text('spamAlreadyUnlocked', 'Spam already unlocked.')
        set_text('spamUnlocked', 'Spam unlocked.')
        set_text('floodSensibility', '\nFlood sensibility: ')
        set_text('floodUnlockOwners', 'Only owners can unlock flood.')
        set_text('floodLock', '\nLock flood: ')
        set_text('floodAlreadyLocked', 'Flood already locked.')
        set_text('floodLocked', 'Flood locked.')
        set_text('floodAlreadyUnlocked', 'Flood already unlocked.')
        set_text('floodUnlocked', 'Flood unlocked.')
        set_text('arabicLock', '\nLock arabic: ')
        set_text('arabicAlreadyLocked', 'Arabic already locked.')
        set_text('arabicLocked', 'Arabic locked.')
        set_text('arabicAlreadyUnlocked', 'Arabic already unlocked.')
        set_text('arabicUnlocked', 'Arabic unlocked.')
        set_text('botsLock', '\nLock bots: ')
        set_text('botsAlreadyLocked', 'Bots already locked.')
        set_text('botsLocked', 'Bots locked.')
        set_text('botsAlreadyUnlocked', 'Bots already unlocked.')
        set_text('botsUnlocked', 'Bots unlocked.')
        set_text('linksLock', '\nLock links: ')
        set_text('linksAlreadyLocked', 'Links already locked.')
        set_text('linksLocked', 'Links locked.')
        set_text('linksAlreadyUnlocked', 'Links already unlocked.')
        set_text('linksUnlocked', 'Links unlocked.')
        set_text('rtlLock', '\nLock RTL: ')
        set_text('rtlAlreadyLocked', 'RTL characters already locked già vietati.')
        set_text('rtlLocked', 'RTL characters locked.')
        set_text('rtlAlreadyUnlocked', 'RTL characters already unlocked.')
        set_text('rtlUnlocked', 'RTL characters unlocked.')
        set_text('tgserviceLock', '\nLock service messages: ')
        set_text('tgserviceAlreadyLocked', 'Service messages already locked.')
        set_text('tgserviceLocked', 'Service messages locked.')
        set_text('tgserviceAlreadyUnlocked', 'Service messages already unlocked.')
        set_text('tgserviceUnlocked', 'Service messages unlocked.')
        set_text('stickersLock', '\nLock stickers: ')
        set_text('stickersAlreadyLocked', 'Stickers already locked.')
        set_text('stickersLocked', 'Stickers locked.')
        set_text('stickersAlreadyUnlocked', 'Stickers already unlocked.')
        set_text('stickersUnlocked', 'Stickers unlocked.')
        set_text('public', '\nPublic: ')
        set_text('publicAlreadyYes', 'Group already public.')
        set_text('publicYes', 'Public group.')
        set_text('publicAlreadyNo', 'Group already private.')
        set_text('publicNo', 'Private group.')
        set_text('contactsAlreadyLocked', 'Contacts already locked.')
        set_text('contactsLocked', 'Contacts locked.')
        set_text('contactsAlreadyUnlocked', 'Contacts already unlocked.')
        set_text('contactsUnlocked', 'Contacts unlocked.')
        set_text('strictrules', '\nStrict rules: ')
        set_text('strictrulesAlreadyLocked', 'Strict rules already enabled.')
        set_text('strictrulesLocked', 'Strict rules enabled.')
        set_text('strictrulesAlreadyUnlocked', 'Strict rules already disabled.')
        set_text('strictrulesUnlocked', 'Strict rules disabled.')

        -- onservice.lua --
        set_text('notMyGroup', 'This is not one of my groups, bye.')

        -- owners.lua --
        set_text('notTheOwner', 'You are not the owner of this group.')
        set_text('noAutoUnban', 'You can\'t unban yourself.')

        -- plugins.lua --
        set_text('enabled', ' enabled.')
        set_text('disabled', ' disabled.')
        set_text('alreadyEnabled', ' already enabled.')
        set_text('alreadyDisabled', ' already disabled.')
        set_text('notExist', '  not exists.')
        set_text('systemPlugin', '⛔️ You can\'t disable this plugin because is a system one.')
        set_text('disabledOnChat', ' disabled on chat.')
        set_text('noDisabledPlugin', '❔ No plugins disabled on chat.')
        set_text('pluginNotDisabled', '✔️ This plugin is not disabled on chat.')
        set_text('pluginEnabledAgain', ' enabled on chat again.')
        set_text('pluginsReloaded', '💊 Plugins reloaded.')

        -- pokedex.lua --
        set_text('noPoke', 'No pokémon found.')
        set_text('pokeName', 'Name: ')
        set_text('pokeWeight', 'Weight: ')
        set_text('pokeHeight', 'Height: ')

        -- ruleta.lua --
        set_text('alreadySignedUp', 'You\'re already registered, use /ruleta to die.')
        set_text('signedUp', 'You\'ve been registered, have a nice death.')
        set_text('notSignedUp', 'You\'re not registered.')
        set_text('ruletaDeleted', 'You\'ve been deleted from the game.')
        set_text('requireSignUp', 'Before dying you need to be registered.')
        set_text('groupAlreadySignedUp', 'Group already registered.')
        set_text('groupSignedUp', 'Group registered with default values (cylinder capacity: 6 bullets: 1).')
        set_text('ruletaGroupDeleted', 'Group disabled for ruleta.')
        set_text('requireGroupSignUp', 'Before playing the group must be registered.')
        set_text('requirePoints', 'Require at least 11 points.')
        set_text('requireZeroPoints', 'You can\'t be deleted with a score < 0.')
        set_text('challenge', 'CHALLENGE')
        set_text('challenger', 'Challenger: ')
        set_text('challenged', 'Challenged: ')
        set_text('challengeModTerminated', 'Challenge terminated by mod.')
        set_text('challengeRejected', 'Challenged rejected challenge, coward!')
        set_text('notAccepted', 'Not accepted yet.')
        set_text('accepted', 'Ongoing.')
        set_text('roundsLeft', 'Rounds Left: ')
        set_text('shotsLeft', 'Shots Left: ')
        set_text('notYourTurn', 'Not your turn.')
        set_text('yourTurn', ' it\'s your turn.')
        set_text('challengeEnd', 'Dead, Challenge finished.')
        set_text('noChallenge', 'No ongoing challenge.')
        set_text('errorOngoingChallenge', 'Can\'t start multiple challenges at the same time.')
        set_text('challengeSet', 'Challenge started, challenged can accept with /accetta or reject with /rifiuta.')
        set_text('wrongPlayer', 'You\'re not the challenged.')
        set_text('capsChanged', 'Bullets in gun: ')
        set_text('challengeCapsChanged', 'Bullets in challenge gun: ')
        set_text('cylinderChanged', 'New cylinder capacity: ')
        set_text('challengeCylinderChanged', 'New challenge cylinder capacity: ')
        set_text('errorCapsRange', 'Error, range is [1-X].')
        set_text('errorCylinderRange', 'Error, range is [5-10].')
        set_text('cylinderCapacity', 'Cylinder capacity: ')
        set_text('challengeCylinderCapacity', 'Challenge cylinder capacity: ')
        set_text('capsNumber', 'Bullets: ')
        set_text('challengeCapsNumber', 'Challenge bullets: ')
        set_text('deaths', 'Deaths: ')
        set_text('duels', 'Challenges: ')
        set_text('wonduels', 'Won challenges: ')
        set_text('lostduels', 'Lost challenges: ')
        set_text('actualstreak', 'Actual streak: ')
        set_text('longeststreak', 'Longest streak: ')
        set_text('attempts', 'Total attempts: ')
        set_text('score', 'Score: ')

        -- set.lua --
        set_text('saved', ' saved.')

        -- spam.lua --
        set_text('msgSet', 'Message set.')
        set_text('msgsToSend', 'Messages to send: ')
        set_text('timeBetweenMsgs', 'Time between every message: X seconds.')
        set_text('msgNotSet', 'You haven\'t set the message, use /setspam.')

        -- stats.lua --
        set_text('usersInChat', 'Users on chat\n')
        set_text('groups', '\nGroups: ')

        -- strings.lua --
        set_text('langUpdate', 'ℹ️ Strings updated.')

        -- supergroup.lua --
        set_text('makeBotAdmin', 'Promote me as administrator!')
        set_text('groupIs', 'This is a group.')
        set_text('supergroupAlreadyAdded', 'Supergroup already added.')
        set_text('errorAlreadySupergroup', 'Error, already a supergroup.')
        set_text('supergroupAdded', 'Supergroup has been added.')
        set_text('supergroupRemoved', 'Supergroup has been removed.')
        set_text('supergroupNotAdded', 'Supergroup not added.')
        set_text('membersOf', 'Members of ')
        set_text('membersKickedFrom', 'Members kicked from ')
        set_text('cantKickOtherAdmin', 'You can\'t kick other admins.')
        set_text('promoteSupergroupMod', ' has been promoted to administrator (telegram).')
        set_text('demoteSupergroupMod', ' has been demoted from administrator (telegram).')
        set_text('alreadySupergroupMod', ' is already an administrator (telegram).')
        set_text('notSupergroupMod', ' is not an administrator (telegram).')
        set_text('cantDemoteOtherAdmin', 'You can\'t demote other admins.')
        set_text('leftKickme', 'Left using /kickme.')
        set_text('setOwner', ' is the owner.')
        set_text('inThisSupergroup', ' in this supergroup.')
        set_text('sendLink', 'Send me the group link.')
        set_text('linkSaved', 'New link set.')
        set_text('supergroupUsernameChanged', 'Supergroup username changed.')
        set_text('errorChangeUsername', 'Error changing username.\nIt could be already in use.\n\nYou can use letters numbers and underscore.\nMinimum length 5 characters.')
        set_text('usernameCleaned', 'Supergroup username cleaned.')
        set_text('errorCleanedUsername', 'Error while cleaning supergroup username.')

        -- unset.lua --
        set_text('deleted', ' deleted.')

        -- warn.lua --
        set_text('errorWarnRange', 'Error, range is [1-10].')
        set_text('warnSet', 'Warn has been set to ')
        set_text('noWarnSet', 'Warn hasn\t been set yet.')
        set_text('cantWarnHigher', 'You can\'t warn mod/owner/admin/sudo!')
        set_text('warned', 'You\'ve been warned X times, calm down!')
        set_text('unwarned', 'One warn has been deleted, keep it up!')
        set_text('alreadyZeroWarnings', 'You\'re already at zero warns.')
        set_text('zeroWarnings', 'Your warns has been removed.')
        set_text('yourWarnings', 'You\'re at X warns on Y.')

        -- welcome.lua --
        set_text('newWelcome', 'New welcome message:\n')
        set_text('newWelcomeNumber', 'Welcome message will be sent every X members.')
        set_text('noSetValue', 'No value set.')

        -- whitelist.lua --
        set_text('userBot', 'User/Bot ')
        set_text('whitelistRemoved', ' removed from whitelist.')
        set_text('whitelistAdded', ' added to whitelist.')
        set_text('whitelistCleaned', 'Whitelist cleaned.')

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
