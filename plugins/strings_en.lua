--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------

local LANG = 'en:'

local function run(msg, matches)
    if is_sudo(msg) then
        -------------
        -- Plugins --
        -------------

        redis:set('lang', LANG)

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

        -- botinteract.lua --
        set_text('botSet', ' has been saved to interact with chat.')
        set_text('botUnset', ' has been removed from bots to interact with.')
        set_text('mediaNotSupported', 'Media not supported yet.')

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
        set_text('youTried', 'You tried it, you won\'t read an help higher than the one you deserve, asshole.')

        -- goodbyewelcome.lua --
        set_text('newWelcome', 'New welcome message:\n')
        set_text('newGoodbye', 'New goodbye message:\n')
        set_text('welcomeRemoved', 'Welcome removed.')
        set_text('goodbyeRemoved', 'Goodbye removed.')
        set_text('newWelcomeNumber', 'Welcome message will be sent every X members.')
        set_text('neverWelcome', 'Welcome message will not be sent anymore.')
        set_text('noSetValue', 'No value set.')

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
        set_text('rank', '\nRank: ')
        set_text('date', '\nDate: ')
        set_text('totalMessages', '\nTotal messages: ')
        set_text('otherInfo', '\nOther info: ')
        set_text('youAreWriting', '\n\nYou are writing to')
        set_text('groupName', '\nGroup name: ')
        set_text('supergroupName', '\nSupergroup name: ')
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
        set_text('groupsJoin', 'Groups:\nUse /join <group_id> to join\n\n')
        set_text('realmsJoin', 'Realm:\nUse /join <realm_id> to join\n\n')
        set_text('youGbanned', 'You are globally banned.')
        set_text('youBanned', 'You are banned.')
        set_text('chatNotFound', 'Chat not found.')
        set_text('privateGroup', 'Private group.')
        set_text('addedTo', 'You\'ve been added to: ')
        set_text('supportAdded', 'Support added ')
        set_text('adminAdded', 'Admin added ')
        set_text('toChat', ' to 👥 ')
        set_text('aliasSaved', 'Alias saved.')
        set_text('aliasDeleted', 'Alias deleted.')
        set_text('noAliasFound', 'No group with that alias.')

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
        set_text('notExists', ' not exists.')
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
        set_text('requireSignUp', 'Before dying you need to be registered, use /registerme.')
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
        set_text('cantChallengeYourself', 'You can\'t start a challenge with yourself.')
        set_text('cantChallengeMe', 'You can\'t start a challenge with me, you would lose it.')
        set_text('notAccepted', 'Not accepted yet.')
        set_text('accepted', 'Ongoing.')
        set_text('roundsLeft', 'Rounds Left: ')
        set_text('shotsLeft', 'Shots Left: ')
        set_text('notYourTurn', 'Not your turn.')
        set_text('yourTurn', ' it\'s your turn.')
        set_text('challengeEnd', 'Dead, Challenge finished.')
        set_text('noChallenge', 'No ongoing challenge.')
        set_text('errorOngoingChallenge', 'Can\'t start multiple challenges at the same time.')
        set_text('challengeSet', 'Challenge started, challenged can accept with /accept or reject with /reject.')
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
        set_text('cheating', 'Cheat used.')
        set_text('scoreLeaderboard', 'Score leaderboard\n')

        -- set.lua --
        set_text('saved', ' saved.')
        set_text('sendMedia', 'Send me the media you want to save (audio or picture).')
        set_text('cancelled', 'Cancelled.')
        set_text('nothingToSet', 'Nothing to set.')
        set_text('mediaSaved', 'Media saved.')

        -- spam.lua --
        set_text('msgSet', 'Message set.')
        set_text('msgsToSend', 'Messages to send: ')
        set_text('timeBetweenMsgs', 'Time between every message: X seconds.')
        set_text('msgNotSet', 'You haven\'t set the message, use /setspam.')

        -- stats.lua --
        set_text('usersInChat', 'Users on chat\n')
        set_text('groups', '\nGroups: ')
        set_text('statsCleaned', 'Stats cleaned.')

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
        set_text('linkSaved', 'New link set.')
        set_text('supergroupUsernameChanged', 'Supergroup username changed.')
        set_text('errorChangeUsername', 'Error changing username.\nIt could be already in use.\n\nYou can use letters numbers and underscore.\nMinimum length 5 characters.')
        set_text('usernameCleaned', 'Supergroup username cleaned.')
        set_text('errorCleanedUsername', 'Error while cleaning supergroup username.')

        -- unset.lua --
        set_text('deleted', ' deleted.')

        -- warn.lua --
        set_text('errorWarnRange', 'Error, range is [0-10].')
        set_text('warnSet', 'Warn has been set to ')
        set_text('neverWarn', 'Warn will not work anymore.')
        set_text('noWarnSet', 'Warn hasn\t been set yet.')
        set_text('cantWarnHigher', 'You can\'t warn mod/owner/admin/sudo!')
        set_text('warned', 'You\'ve been warned X times, calm down!')
        set_text('unwarned', 'One warn has been deleted, keep it up!')
        set_text('alreadyZeroWarnings', 'You\'re already at zero warns.')
        set_text('zeroWarnings', 'Your warns has been removed.')
        set_text('yourWarnings', 'You\'re at X warns on Y.')

        -- whitelist.lua --
        set_text('userBot', 'User/Bot ')
        set_text('whitelistRemoved', ' removed from whitelist.')
        set_text('whitelistAdded', ' added to whitelist.')
        set_text('whitelistCleaned', 'Whitelist cleaned.')

        ------------
        -- Usages --
        ------------
        -- administrator.lua --
        set_text('administrator:0', 20)
        set_text('administrator:1', 'ADMIN')
        set_text('administrator:2', '(#pm|sasha messaggia) <user_id> <msg>: Sasha writes <msg> to <user_id>.')
        set_text('administrator:3', '#import <group_link>: Sasha joins <group_link>.')
        set_text('administrator:4', '(#block|sasha blocca) <user_id>: Sasha blocks <user_id>.')
        set_text('administrator:5', '(#unblock|sasha sblocca) <user_id>: Sasha unblocks <user_id>.')
        set_text('administrator:6', '(#markread|sasha segna letto) (on|off): Sasha marks as [not] read messages that receives.')
        set_text('administrator:7', '(#setbotphoto|sasha cambia foto): Sasha waits for a pic to set as bot\'s profile.')
        set_text('administrator:8', '(#updateid|sasha aggiorna longid): Sasha saves long_id.')
        set_text('administrator:9', '(#addlog|sasha aggiungi log): Sasha adds log.')
        set_text('administrator:10', '(#remlog|sasha rimuovi log): Sasha removes log.')
        set_text('administrator:11', 'SUDO')
        set_text('administrator:12', '(#contactlist|sasha lista contatti) (txt|json): Sasha sends contacts list.')
        set_text('administrator:13', '(#dialoglist|sasha lista chat) (txt|json): Sasha sends chats list.')
        set_text('administrator:14', '(#addcontact|sasha aggiungi contatto) <phone> <name> <surname>: Sasha adds specified contact.')
        set_text('administrator:15', '(#delcontact|sasha elimina contatto) <user_id>: Sasha deletes contact of <user_id>.')
        set_text('administrator:16', '(#sendcontact|sasha invia contatto) <phone> <name> <surname>: Sasha sends contact with specified information.')
        set_text('administrator:17', '(#mycontact|sasha mio contatto): Sasha sends sender contact.')
        set_text('administrator:18', '(#sync_gbans|sasha sincronizza superban): Sasha syncs gbans list with the one offered by TeleSeed.')
        set_text('administrator:19', '(#backup|sasha esegui backup): Sasha makes a backup of herself and sends log to the sender.')
        set_text('administrator:20', '#vardump [<reply>|<msg_id>]: Sasha sends vardump of specified message.')

        -- anti_spam.lua --
        set_text('anti_spam:0', 1)
        set_text('anti_spam:1', 'Sasha kicks user that was flooding.')

        -- apod.lua --
        set_text('apod:0', 4)
        set_text('apod:1', '#(apod|astro) [<date>]: Sasha sends APOD.')
        set_text('apod:2', '#(apod|astro)hd [<date>]: Sasha sends APOD in HD.')
        set_text('apod:3', '#(apod|astro)text [<date>]: Sasha sends explanation of the APOD.')
        set_text('apod:4', 'If <date> is specified and it\'s in this format AAAA-MM-GG the APOD refers to <date>.')

        -- arabic_lock.lua --
        set_text('arabic_lock:0', 1)
        set_text('arabic_lock:1', 'Sasha blocks arabic in groups.')

        -- banhammer.lua --
        set_text('banhammer:0', 13)
        set_text('banhammer:1', '(#kickme|sasha uccidimi): Sasha kicks sender.')
        set_text('banhammer:2', 'MOD')
        set_text('banhammer:3', '(#kick|spara|[sasha] uccidi) <id>|<username>|<reply>: Sasha kicks specified user.')
        set_text('banhammer:4', '(#ban|esplodi|kaboom|[sasha] banna|[sasha] decompila) <id>|<username>|<reply>: Sasha kicks and bans specified user, if he tries to join again it\'s automatically kicked.')
        set_text('banhammer:5', '(#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>: Sasha unbans specified user.')
        set_text('banhammer:6', '(#banlist|[sasha] lista ban) [<group_id>]: Sasha sends bans list of the group or of <group_id>.')
        set_text('banhammer:7', 'OWNER')
        set_text('banhammer:8', '(#kicknouser|[sasha] uccidi nouser|spara nouser): Sasha kicks users without username.')
        set_text('banhammer:9', '(#kickinactive [<msgs>]|((sasha uccidi)|spara sotto <msgs> messaggi)): Sasha kicks inactive users under <msgs> messages.')
        set_text('banhammer:10', 'SUPPORT')
        set_text('banhammer:11', '(#gban|[sasha] superbanna) <id>|<username>|<reply>: Sasha kicks and gbans specified user, if he tries to join again it\'s automatically kicked.')
        set_text('banhammer:12', '(#ungban|[sasha] supersbanna) <id>|<username>|<reply>: Sasha ungbans specified user.')
        set_text('banhammer:13', '(#gbanlist|[sasha] lista superban): Sasha sends gbans list.')

        -- bot.lua --
        set_text('bot:0', 2)
        set_text('bot:1', 'OWNER')
        set_text('bot:2', '#bot|sasha on|off: Sasha goes on|off on the group.')

        -- botinteract.lua --
        set_text('botinteract:0', 6)
        set_text('botinteract:1', 'MOD')
        set_text('botinteract:2', '§§<text>: Sasha sends <text> to the bot.')
        set_text('botinteract:3', 'OWNER')
        set_text('botinteract:4', '#unsetbot <username>: Sasha will stop the interaction with <username>.')
        set_text('botinteract:5', 'ADMIN')
        set_text('botinteract:6', '#setbot <username>: Sasha will interact with <username>.')

        -- broadcast.lua --
        set_text('broadcast:0', 4)
        set_text('broadcast:1', 'ADMIN')
        set_text('broadcast:2', '#br <group_id> <text>: Sasha sends <text> to <group_id>.')
        set_text('broadcast:3', 'SUDO')
        set_text('broadcast:4', '#broadcast <text>: Sasha sends <text> to all groups.')

        -- dogify.lua --
        set_text('dogify:0', 1)
        set_text('dogify:1', '(#dogify|[sasha] doge) <your/words/with/slashes>: Sasha creates a pic with doge and specified words.')

        -- duckduckgo.lua --
        set_text('duckduckgo:0', 1)
        set_text('duckduckgo:1', '#duck[duck]go <terms>: Sasha searches <terms> on DuckDuckGo.')

        -- echo.lua --
        set_text('echo:0', 2)
        set_text('echo:1', 'MOD')
        set_text('echo:2', '(#echo|sasha ripeti) <text>: Sasha repeat <text>.')

        -- feedback.lua --
        set_text('feedback:0', 1)
        set_text('feedback:1', '#feedback <text>: Sasha sends <text> to her creator.')

        -- filemanager.lua --
        set_text('filemanager:0', 15)
        set_text('filemanager:1', 'SUDO')
        set_text('filemanager:2', '#folder: Sasha sends actual directory.')
        set_text('filemanager:3', '#cd [<directory>]: Sasha enters in <directory>, if it\'s not specified it returns to base folder.')
        set_text('filemanager:4', '#ls: Sasha sends the list of files and folders of the current directory.')
        set_text('filemanager:5', '#mkdir <directory>: Sasha creates <directory>.')
        set_text('filemanager:6', '#rmdir <directory>: Sasha deletes <directory>.')
        set_text('filemanager:7', '#rm <file>: Sasha deletes <file>.')
        set_text('filemanager:8', '#touch <file>: Sasha creates <file>.')
        set_text('filemanager:9', '#cat <file>: Sasha sends <file> content.')
        set_text('filemanager:10', '#tofile <file> <text>: Sasha creates <file> with <text> as content.')
        set_text('filemanager:11', '#shell <command>: Sasha executes <command>.')
        set_text('filemanager:12', '#cp <file> <directory>: Sasha copies <file> in <directory>.')
        set_text('filemanager:13', '#mv <file> <directory>: Sasha moves <file> in <directory>.')
        set_text('filemanager:14', '#upload <file>: Sasha uploads <file> on chat.')
        set_text('filemanager:15', '#download <reply>: Sasha downloads the file in <reply>.')

        -- flame.lua --
        set_text('flame:0', 4)
        set_text('flame:1', 'MOD')
        set_text('flame:2', '(#startflame|[sasha] flamma) <id>|<username>|<reply>: Sasha flames specified user.')
        set_text('flame:3', '(#stopflame|[sasha] stop flame): Sasha stops flame.')
        set_text('flame:4', '(#flameinfo|[sasha] info flame): Sasha sends flamed user info.')

        -- get.lua --
        set_text('get:0', 2)
        set_text('get:1', '(#getlist|#get|sasha lista): Sasha sends a list of saved variables.')
        set_text('get:2', '[#get] <var_name>: Sasha sends value of <var_name>.')

        -- goodbyewelcome.lua --
        set_text('goodbyewelcome:0', 9)
        set_text('goodbyewelcome:1', '#getwelcome: Sasha sends welcome.')
        set_text('goodbyewelcome:2', '#getgoodbye: Sasha sends goodbye.')
        set_text('goodbyewelcome:3', 'MOD')
        set_text('goodbyewelcome:4', '#setwelcome <text>: Sasha sets <text> as welcome.')
        set_text('goodbyewelcome:5', '#setgoodbye <text>: Sasha sets <text> as goodbye.')
        set_text('goodbyewelcome:6', '#unsetwelcome: Sasha removes welcome.')
        set_text('goodbyewelcome:7', '#unsetgoodbye: Sasha removes goodbye.')
        set_text('goodbyewelcome:8', '#setmemberswelcome <value>: Sasha after <value> members will send welcome, if zero welcome will not be sent anymore.')
        set_text('goodbyewelcome:9', '#getmemberswelcome: Sasha sends value of users that are needed to get welcome.')

        -- help.lua --
        set_text('help:0', 5)
        set_text('help:1', '(#sudolist|sasha lista sudo): Sasha sends sudo list.')
        set_text('help:2', '(#help|sasha aiuto): Sasha sends a list of plugins.')
        set_text('help:3', '(#help|commands|sasha aiuto) <plugin_name>|<plugin_number> [<fake_rank>]: Sasha sends help of specified plugin.')
        set_text('help:4', '(#helpall|allcommands|sasha aiuto tutto) [<fake_rank>]: Sasha sends help of all plugins.')
        set_text('help:5', '<fake_rank> parameter is necessary to get a help of a lower rank, ranks are: USER, MOD, OWNER, SUPPORT, ADMIN, SUDO.')

        -- info.lua --
        set_text('info:0', 10)
        set_text('info:1', '#getrank|rango [<id>|<username>|<reply>]: Sasha sends rank of specified user.')
        set_text('info:2', '(#info|[sasha] info): Sasha sends user\'s info or chat\'s info or her info.')
        set_text('info:3', 'MOD')
        set_text('info:4', '(#info|[sasha] info) <id>|<username>|<reply>|from: Sasha sends info of specified user.')
        set_text('info:5', '(#who|#members|[sasha] lista membri): Sasha users list.')
        set_text('info:6', '(#kicked|[sasha] lista rimossi): Sasha sends kicked users list.')
        set_text('info:7', 'OWNER')
        set_text('info:8', '(#groupinfo|[sasha] info gruppo) [<group_id>]: Sasha sends info of specified group.')
        set_text('info:9', 'SUDO')
        set_text('info:10', '(#database|[sasha] database): Sasha saves all info of all users of group.')

        -- ingroup.lua --
        set_text('ingroup:0', 32)
        set_text('ingroup:1', '(#rules|sasha regole): Sasha sends group\'s rules.')
        set_text('ingroup:2', '(#about|sasha descrizione): Sasha sends group\'s about.')
        set_text('ingroup:3', '(#modlist|[sasha] lista mod): Sasha sends moderators list.')
        set_text('ingroup:4', '#owner: Sasha sends owner\'s id.')
        set_text('ingroup:5', 'MOD')
        set_text('ingroup:6', '#setname|#setgpname <group_name>: Sasha changes group\'s name with <group_name>.')
        set_text('ingroup:7', '#setphoto|#setgpphoto: Sasha waits for a pic to set it as group profile pic.')
        set_text('ingroup:8', '(#setrules|sasha imposta regole) <text>: Sasha changes group\'s rules with <text>.')
        set_text('ingroup:9', '(#setabout|sasha imposta descrizione) <text>: Sasha changes group\'s about with <text>.')
        set_text('ingroup:10', '(#lock|[sasha] blocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha locks specified parameter.')
        set_text('ingroup:11', '(#unlock|[sasha] sblocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha unlocks specified parameter.')
        set_text('ingroup:12', '#muteuser|voce <id>|<username>|<reply>: Sasha [un]mute specified user.')
        set_text('ingroup:13', '(#muteslist|lista muti): Sasha sends muted parameters list.')
        set_text('ingroup:14', '(#mutelist|lista utenti muti): Sasha sends muted users list.')
        set_text('ingroup:15', '#settings: Sasha sends group settings.')
        set_text('ingroup:16', '#public yes|no: Sasha makes group public|private.')
        set_text('ingroup:17', '(#newlink|sasha crea link): Sasha creates group\'s link.')
        set_text('ingroup:18', '(#link|sasha link): Sasha sends group\'s link.')
        set_text('ingroup:19', '#setflood <value>: Sasha sets <value> as max flood.')
        set_text('ingroup:20', 'OWNER')
        set_text('ingroup:21', '(#setlink|[sasha] imposta link) <link>: Sasha saves <link> as group\'s link.')
        set_text('ingroup:22', '(#promote|[sasha] promuovi) <username>|<reply>: Sasha promotes to mod specified user.')
        set_text('ingroup:23', '(#demote|[sasha] degrada) <username>|<reply>: Sasha demotes from mod specified user.')
        set_text('ingroup:24', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha mute specified parameter.')
        set_text('ingroup:25', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha unmute specified parameter.')
        set_text('ingroup:26', '#setowner <id>: Sasha sets <id> as owner.')
        set_text('ingroup:27', '#clean modlist|rules|about: Sasha cleans specified parameter.')
        set_text('ingroup:28', 'ADMIN')
        set_text('ingroup:29', '#add [realm]: Sasha adds group|realm.')
        set_text('ingroup:30', '#rem [realm]: Sasha removes group|realm.')
        set_text('ingroup:31', '#kill group|supergroup|realm: Sasha kicks every user in group|supergroup|realm and removes it.')
        set_text('ingroup:32', '#setgpowner <group_id> <user_id>: Sasha sets <user_id> as owner of <group_id>.')

        -- inpm.lua --
        set_text('inpm:0', 10)
        set_text('inpm:1', '#chats: Sasha sends a "public" chats list.')
        set_text('inpm:2', '#chatlist: Sasha sends a file with "public" chats list.')
        set_text('inpm:3', 'ADMIN')
        set_text('inpm:4', '#join <chat_id>|<alias> [support]: Sasha tries to add the sender to <chat_id>|<alias>.')
        set_text('inpm:5', '#getaliaslist: Sasha sends alias list.')
        set_text('inpm:6', 'SUDO')
        set_text('inpm:7', '#allchats: Sasha sends a list of all chats.')
        set_text('inpm:8', '#allchatlist: Sasha sends a file with a list of all chats.')
        set_text('inpm:9', '#setalias <alias> <group_id>: Sasha sets <alias> as alias of <group_id>.')
        set_text('inpm:10', '#unsetalias <alias>: Sasha deletes <alias>.')

        -- inrealm.lua --
        set_text('inrealm:0', 25)
        set_text('inrealm:1', 'MOD')
        set_text('inrealm:2', '#who: Sasha sends a list of all group|realm members.')
        set_text('inrealm:3', '#wholist: Sasha sends a file with a list of all group/realm members.')
        set_text('inrealm:4', 'OWNER')
        set_text('inrealm:5', '#log: Sasha sends a file that contains group/realm log.')
        set_text('inrealm:6', 'ADMIN')
        set_text('inrealm:7', '(#creategroup|sasha crea gruppo) <group_name>: Sasha creates a group with specified name.')
        set_text('inrealm:8', '(#createsuper|sasha crea supergruppo) <group_name>: Sasha creates a supergroup with specified name.')
        set_text('inrealm:9', '(#createrealm|sasha crea regno) <realm_name>: Sasha creates a realm with specified name.')
        set_text('inrealm:10', '(#setabout|sasha imposta descrizione) <group_id> <text>: Sasha changes <group_id>\'s about with <text>.')
        set_text('inrealm:11', '(#setrules|sasha imposta regole) <group_id> <text>: Sasha changes <group_id>\'s rules with <text>.')
        set_text('inrealm:12', '#setname <realm_name>: Sasha changes realm\'s name with <realm_name>.')
        set_text('inrealm:13', '#setname|#setgpname <group_id> <group_name>: Sasha changes <group_id>\'s name with <group_name>.')
        set_text('inrealm:14', '(#lock|[sasha] blocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha locks <group_id>\'s specified setting.')
        set_text('inrealm:15', '(#unlock|[sasha] sblocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha unlocks <group_id>\'s specified setting.')
        set_text('inrealm:16', '#settings <group_id>: Sasha sends <group_id>\'s settings.')
        set_text('inrealm:17', '#type: Sasha sends group\'s type.')
        set_text('inrealm:18', '#kill group|supergroup|realm <group_id>: Sasha kicks all members of <group_id> and removes <group_id>.')
        set_text('inrealm:19', '#rem <group_id>: Sasha removes group.')
        set_text('inrealm:20', '#support <user_id>|<username>: Sasha promotes specified user to support.')
        set_text('inrealm:21', '#-support <user_id>|<username>: Sasha demotes specified user from support.')
        set_text('inrealm:22', '#list admins|groups|realms: Sasha sends list of specified parameter.')
        set_text('inrealm:23', 'SUDO')
        set_text('inrealm:24', '#addadmin <user_id>|<username>: Sasha promotes specified user to administrator.')
        set_text('inrealm:25', '#removeadmin <user_id>|<username>: Sasha demotes specified user from administrator.')

        -- interact.lua --
        set_text('interact:0', 1)
        set_text('interact:1', 'Sasha interacts with users.')

        -- invite.lua --
        set_text('invite:0', 2)
        -- set_text('invite:1','OWNER')
        set_text('invite:1', 'ADMIN')
        set_text('invite:2', '(#invite|[sasha] invita|[sasha] resuscita) <id>|<username>|<reply>: Sasha invites specified user.')

        -- leave_ban.lua --
        set_text('leave_ban:0', 1)
        set_text('leave_ban:1', 'Sasha bans leaving users.')

        -- msg_checks.lua --
        set_text('msg_checks:0', 1)
        set_text('msg_checks:1', 'Sasha checks received messages.')

        -- onservice.lua --
        set_text('onservice:0', 2)
        set_text('onservice:1', 'ADMIN')
        set_text('onservice:2', '(#leave|sasha abbandona): Sasha leaves group.')

        -- owners.lua --
        set_text('owners:0', 5)
        -- set_text('owners:1','#owners <group_id>: Sasha sends <group_id>\'s log.')
        set_text('owners:1', '#changeabout <group_id> <text>: Sasha changes <group_id>\'s about with <text>.')
        set_text('owners:2', '#changerules <group_id> <text>: Sasha changes <group_id>\'s rules with <text>.')
        set_text('owners:3', '#changename <group_id> <text>: Sasha changes <group_id>\'s name with <text>.')
        set_text('owners:4', '#viewsettings <group_id>: Sasha sends <group_id>\'s settings.')
        set_text('owners:5', '#loggroup <group_id>: Sasha sends <group_id>\'s log.')

        -- plugins.lua --
        set_text('plugins:0', 9)
        set_text('plugins:1', 'OWNER')
        set_text('plugins:2', '(#disabledlist|([sasha] lista disabilitati|disattivati)): Sasha sends disabled plugins list.')
        set_text('plugins:3', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> chat: Sasha re enables <plugin> on this chat.')
        set_text('plugins:4', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> chat: Sasha disables <plugin> on this chat.')
        set_text('plugins:5', 'SUDO')
        set_text('plugins:6', '(#plugins|[sasha] lista plugins): Sasha mostra una lista di tutti i plugins.')
        set_text('plugins:7', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> [chat]: Sasha enables <plugin>, if specified just on chat.')
        set_text('plugins:8', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> [chat]: Sasha disables <plugin>, if specified just on chat.')
        set_text('plugins:9', '(#[plugin[s]] reload|[sasha] ricarica): Sasha reloads all plugins.')

        -- pokedex.lua --
        set_text('pokedex:0', 1)
        set_text('pokedex:1', '#pokedex|#pokemon <name>|<id>: Sasha searches specified pokemon and sends its info.')

        -- qr.lua --
        set_text('qr:0', 5)
        set_text('qr:1', '(#qr|sasha qr) ["<background_color>" "<data_color>"] <text>: Sasha creates QR Code of <text>, if specified it colors QR Code.')
        set_text('qr:2', 'Colors can be specified as follows:')
        set_text('qr:3', 'Text => red|green|blue|purple|black|white|gray.')
        set_text('qr:4', 'Hexadecimal => ("a56729" è marrone).')
        set_text('qr:5', 'Decimal => ("255-192-203" è rosa).')

        -- reactions.lua --
        set_text('reactions:0', 2)
        set_text('reactions:1', 'SUDO')
        set_text('reactions:2', '#writing on|off: Sasha (pretends|stops pretending) to write.')

        -- ruleta.lua --
        set_text('ruleta:0', 24)
        set_text('ruleta:1', 'Ruleta by AISasha, inspired from Leia (#RIP) and Arya. Ruleta is the russian roulette with gun, cylinder and bullets, the cylinder rotates and if there\'s the bullet Sasha kicks you.')
        set_text('ruleta:2', '#registerme|#registrami: Sasha registers user to the game.')
        set_text('ruleta:3', '#deleteme|#eliminami: Sasha deletes user from the game.')
        set_text('ruleta:4', '#ruletainfo: Sasha sends gun\'s info.')
        set_text('ruleta:5', '#mystats|#punti: Sasha sends user stats.')
        set_text('ruleta:6', '#ruleta: Sasha tries to kill you.')
        set_text('ruleta:7', '#godruleta: Sasha gives you 50% to gain 70 points and 50% to lose them all (requires at least 11 points).')
        set_text('ruleta:8', '#challenge|#sfida <username>|<reply>: Sasha starts a challenge between sender and specified user.')
        set_text('ruleta:9', '#accept|#accetta: Sasha confirms challenge.')
        set_text('ruleta:10', '#reject|#rifiuta: Sasha deletes challenge.')
        set_text('ruleta:11', '#challengeinfo: Sasha sends current challenge info.')
        set_text('ruleta:12', 'MOD')
        set_text('ruleta:13', '#setcaps <value>: Sasha puts <value> bullets in cylinder.')
        set_text('ruleta:14', '#setchallengecaps <value>: Sasha puts <value> bullets in challenge cylinder.')
        set_text('ruleta:15', '(#kick|spara|[sasha] uccidi) random: Sasha chooses a random user and kicks it.')
        set_text('ruleta:16', 'OWNER')
        set_text('ruleta:17', '#setcylinder <value>: Sasha chooses a cylinder with <value> max bullets in the range [5-10].')
        set_text('ruleta:18', '#setchallengecylinder <value>: Sasha chooses a challenge cylinder with <value> max bullets in the range [5-10].')
        set_text('ruleta:19', 'ADMIN')
        set_text('ruleta:20', '#registergroup|#registragruppo: Sasha enables group to play ruleta.')
        set_text('ruleta:21', '#deletegroup|#eliminagruppo: Sasha disables group to play ruleta.')
        set_text('ruleta:22', 'SUDO')
        set_text('ruleta:23', '#createdb: Sasha creates ruleta database.')
        set_text('ruleta:24', '#addpoints <id> <value>: Sasha adds <value> points to specified user.')
        set_text('ruleta:25', '#rempoints <id> <value>: Sasha subtracts <value> points to specified user.')

        -- set.lua --
        set_text('set:0', 4)
        set_text('set:1', 'MOD')
        set_text('set:2', '(#set|[sasha] setta) <var_name> <text>: Sasha saves <text> as answer to <var_name>.')
        set_text('set:3', '(#setmedia|[sasha] setta media) <var_name>: Sasha saves the media (audio or picture) that will be sent as answer to <var_name>.')
        set_text('set:4', '(#cancel|[sasha] annulla): Sasha cancels #setmedia.')

        -- shout.lua --
        set_text('shout:0', 1)
        set_text('shout:1', '(#shout|[sasha] grida|[sasha] urla) <text>: Sasha "shouts" <text>.')

        -- spam.lua --
        set_text('spam:0', 5)
        set_text('spam:1', 'OWNER')
        set_text('spam:2', '#setspam <text>: Sasha sets <text> as the spam message.')
        set_text('spam:3', '#setmsgs <value>: Sasha sets <value> as number of messages to send.')
        set_text('spam:4', '#setwait <seconds>: Sasha sets <seconds> as wait between messages.')
        set_text('spam:5', '(#spam|[sasha] spamma): Sasha starts spamming.')

        -- stats.lua --
        set_text('stats:0', 12)
        set_text('stats:1', '[#]aisasha: Sasha sends her description.')
        set_text('stats:2', 'MOD')
        set_text('stats:3', '(#stats|#messages): Sasha sends chat\'s stats.')
        set_text('stats:4', '(#realstats|#realmessages): Sasha sends chat\'s stats with just group members.')
        set_text('stats:5', '(#cleanstats|#cleanmessages): Sasha cleans chat\'s stats.')
        set_text('stats:6', '(#statslist|#messageslist): Sasha sends file with chat\'s stats.')
        set_text('stats:7', 'ADMIN')
        set_text('stats:8', '(#stats|#messages) group <group_id>: Sasha sends <group_id>\'s stats.')
        set_text('stats:9', '(#realstats|#realmessages) group <group_id>: Sasha sends <group_id>\'s stats with just group members.')
        set_text('stats:10', '(#cleanstats|#cleanmessages) group <group_id>: Sasha cleans <group_id>\'s stats.')
        set_text('stats:11', '(#statslist|#messageslist) group <group_id>: Sasha sends file with <group_id>\'s stats.')
        set_text('stats:12', '(#stats|#messages) aisasha: Sasha sends her stats.')

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
        set_text('supergroup:1', '#owner: Sasha sends owner info.')
        set_text('supergroup:2', '(#modlist|[sasha] lista mod): Sasha moderators list.')
        set_text('supergroup:3', '(#rules|sasha regole): Sasha sends group rules.')
        set_text('supergroup:4', 'MOD')
        set_text('supergroup:5', '(#bots|[sasha] lista bot): Sasha sends bots list.')
        set_text('supergroup:6', '#wholist|#memberslist: Sasha sends a file with members list.')
        set_text('supergroup:7', '#kickedlist: Sasha sends a file with kicked users list.')
        set_text('supergroup:8', '#del <reply>: Sasha deletes specified message.')
        set_text('supergroup:9', '(#newlink|[sasha] crea link): Sasha creates a new link.')
        set_text('supergroup:10', '(#link|sasha link): Sasha sends group\'s link.')
        set_text('supergroup:11', '#setname|setgpname <text>: Sasha changes group\'s name with <text>.')
        set_text('supergroup:12', '#setphoto|setgpphoto: Sasha will change group\'s picture with the one that will be sent.')
        set_text('supergroup:13', '(#setrules|sasha imposta regole) <text>: Sasha changes group\'s rules with <text>.')
        set_text('supergroup:14', '(#setabout|sasha imposta descrizione) <text>: Sasha changes group\'s about with <text>.')
        set_text('supergroup:15', '(#lock|[sasha] blocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha locks specified parameter.')
        set_text('supergroup:16', '(#unlock|[sasha] sblocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha unlocks specified parameter.')
        set_text('supergroup:17', '#setflood <value>: Sasha sets <value> as max flood.')
        set_text('supergroup:18', '#public yes|no: Sasha makes group public|private.')
        set_text('supergroup:19', '#muteuser|voce <id>|<username>|<reply>: Sasha [un]mute specified user.')
        set_text('supergroup:20', '(#muteslist|lista muti): Sasha sends muted parameters list.')
        set_text('supergroup:21', '(#mutelist|lista utenti muti): Sasha sends muted users list.')
        set_text('supergroup:22', '#settings: Sasha sends group\'s settings.')
        set_text('supergroup:23', 'OWNER')
        set_text('supergroup:24', '(#admins|[sasha] lista admin): Sasha sends telegram\'s administrators list.')
        set_text('supergroup:25', '(#setlink|sasha imposta link) <link>: Sasha saves <link> as group\'s link.')
        set_text('supergroup:26', '#setadmin <id>|<username>|<reply>: Sasha promotes specified user to telegram\'s administrator.')
        set_text('supergroup:27', '#demoteadmin <id>|<username>|<reply>: Sasha demotes specified user from telegram\'s administrator.')
        set_text('supergroup:28', '#setowner <id>|<username>|<reply>: Sasha sets specified user as the owner.')
        set_text('supergroup:29', '(#promote|[sasha] promuovi) <id>|<username>|<reply>: Sasha promotes to moderator specified user.')
        set_text('supergroup:30', '(#demote|[sasha] degrada) <id>|<username>|<reply>: Sasha demotes from moderator specified user.')
        set_text('supergroup:31', '#clean rules|about|modlist|mutelist: Sasha cleans specified parameter.')
        set_text('supergroup:32', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha mutes specified parameter.')
        set_text('supergroup:33', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha unmutes specified parameter.')
        set_text('supergroup:34', 'SUPPORT')
        set_text('supergroup:35', '#add: Sasha adds supergroup.')
        set_text('supergroup:36', '#rem: Sasha removes supergroup.')
        set_text('supergroup:37', 'ADMIN')
        set_text('supergroup:38', '#tosuper: Sasha converts group to supergroup.')
        set_text('supergroup:39', '#setusername <text>: Sasha changes group\'s username with <text>.')
        set_text('supergroup:40', 'peer_id')
        set_text('supergroup:41', 'msg.to.id')
        set_text('supergroup:42', 'msg.to.peer_id')
        set_text('supergroup:43', 'SUDO')
        set_text('supergroup:44', '#mp <id>: Sasha promotes <id> to telegram\'s moderator.')
        set_text('supergroup:45', '#md <id>: Sasha demotes <id> from telegram\'s moderator.')

        -- tagall.lua --
        set_text('tagall:0', 2)
        set_text('tagall:1', 'OWNER')
        set_text('tagall:2', '(#tagall|sasha tagga tutti) <text>: Sasha tags all group\'s members and writes <text>.')

        -- tex.lua --
        set_text('tex:0', 1)
        set_text('tex:1', '(#tex|[sasha] equazione) <equation>: Sasha converts <equation> in image.')

        -- unset.lua --
        set_text('unset:0', 2)
        set_text('unset:1', 'MOD')
        set_text('unset:2', '(#unset|[sasha] unsetta) <var_name>: Sasha deletes <var_name>.')

        -- urbandictionary.lua --
        set_text('urbandictionary:0', 1)
        set_text('urbandictionary:1', '(#urbandictionary|#urban|#ud|[sasha] urban|[sasha] ud) <text>: Sasha searches <text> in the Urban Dictionary.')

        -- warn.lua --
        set_text('warn:0', 7)
        set_text('warn:1', 'MOD')
        set_text('warn:2', '#setwarn <value>: Sasha sets max warns to <value>, if zero warns will not work.')
        set_text('warn:3', '#getwarn: Sasha sends max warns value.')
        set_text('warn:4', '(#getuserwarns|[sasha] ottieni avvertimenti) <id>|<username>|<reply>: Sasha sends user\'s warns.')
        set_text('warn:5', '(#warn|[sasha] avverti) <id>|<username>|<reply>: Sasha warns specified user.')
        set_text('warn:6', '#unwarn <id>|<username>|<reply>: Sasha removes one warn from specified user.')
        set_text('warn:7', '(#unwarnall|[sasha] azzera avvertimenti) <id>|<username>|<reply>: Sasha removes all warns from specified user.')

        -- webshot.lua --
        set_text('webshot:0', 14)
        set_text('webshot:1', 'MOD')
        set_text('webshot:2', '(#webshot|[sasha] webshotta) <url> [<size>]: Sasha does a screenshot of <url> and sends it, if <size> is specified it sends of that dimension.')
        set_text('webshot:3', 'Size can be:')
        set_text('webshot:4', 'T: (120 x 90px)')
        set_text('webshot:5', 'S: (200 x 150px)')
        set_text('webshot:6', 'E: (320 x 240px)')
        set_text('webshot:7', 'N: (400 x 300px)')
        set_text('webshot:8', 'M: (640 x 480px)')
        set_text('webshot:9', 'L: (800 x 600px)')
        set_text('webshot:10', 'X: (1024 x 768px)')
        set_text('webshot:11', 'Nmob: (480 x 800px)')
        set_text('webshot:12', 'ADMIN')
        set_text('webshot:13', 'F: Full page (can be a very long process)')
        set_text('webshot:14', 'Fmob: Full page (can be a long process)')

        -- whitelist.lua --
        set_text('whitelist:0', 3)
        set_text('whitelist:1', 'ADMIN')
        set_text('whitelist:2', '#whitelist <id>|<username>|<reply>: Sasha adds|removes specified user to|from whitelist.')
        set_text('whitelist:3', '#clean whitelist: Sasha cleans whitelist.')

        return lang_text('langUpdate')
    else
        return lang_text('require_sudo')
    end
end

return {
    description = "STRINGS",
    patterns =
    {
        '^[#!/]([Ii][Nn][Ss][Tt][Aa][Ll][Ll][Ee][Nn][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        '^[#!/]([Uu][Pp][Dd][Aa][Tt][Ee][Ee][Nn][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        -- installstrings
        '^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ss][Tt][Aa][Ll][Ll][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ee][Nn])$',
        '^([Ii][Nn][Ss][Tt][Aa][Ll][Ll][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ee][Nn])$',
        -- updatestrings
        '^([Ss][Aa][Ss][Hh][Aa] [Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ee][Nn])$',
        '^([Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee] [Ee][Nn])$',
    },
    run = run,
    min_rank = 5
    -- usage
    -- SUDO",
    -- (#updateenstrings|#installenstrings|[sasha] installa|[sasha] aggiorna) stringhe en
}
