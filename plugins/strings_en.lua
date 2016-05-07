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
        set_text(LANG .. 'require_sudo', '🚫 This plugin requires sudo privileges.')
        set_text(LANG .. 'require_admin', '🚫 This plugin requires admin privileges or higher.')
        set_text(LANG .. 'require_owner', '🚫 This plugin requires owner privileges or higher.')
        set_text(LANG .. 'require_mod', '🚫 This plugin requires mod privileges or higher.')
        set_text(LANG .. 'errorTryAgain', 'Error, try again.')
        set_text(LANG .. 'opsError', 'Ops, error.')
        set_text(LANG .. 'useYourGroups', 'Use it in your groups!')
        set_text(LANG .. 'cantKickHigher', 'You can\'t remove mod/owner/admin/sudo!')
        set_text(LANG .. 'user', 'User ')
        set_text(LANG .. 'kicked', ' kicked.')
        set_text(LANG .. 'banned', ' banned.')
        set_text(LANG .. 'unbanned', ' unbanned.')
        set_text(LANG .. 'gbanned', ' globally banned.')
        set_text(LANG .. 'ungbanned', ' globally unbanned.')

        -- seedbot.lua --
        set_text(LANG .. 'sender', 'Sender: ')
        set_text(LANG .. 'receiver', 'Receiver: ')
        set_text(LANG .. 'msgText', 'Message: ')

        -- utils.lua --
        set_text(LANG .. 'errorImageDownload', 'Error downloading the picture.')
        set_text(LANG .. 'banListStart', 'Banlist:\n\n')
        set_text(LANG .. 'gbanListStart', 'GBanlist:\n\n')
        set_text(LANG .. 'mutedUsersStart', 'Muted users of:')
        set_text(LANG .. 'mutedTypesStart', 'Mutes of:')
        set_text(LANG .. 'mute', 'Mute ')
        set_text(LANG .. 'alreadyEnabled', ' already enabled.')
        set_text(LANG .. 'enabled', ' enabled.')
        set_text(LANG .. 'alreadyDisabled', ' already disabled.')
        set_text(LANG .. 'disabled', ' disabled')
        set_text(LANG .. 'noAutoKick', 'You can\'t kick yourself.')
        set_text(LANG .. 'noAutoBan', 'You can\'t ban yourself.')

        -- admin.lua --
        set_text(LANG .. 'sendNewPic', 'Send me the new picture.')
        set_text(LANG .. 'botPicChanged', 'Picture changed!')
        set_text(LANG .. 'logSet', 'Log added.')
        set_text(LANG .. 'logUnset', 'Log removed.')
        set_text(LANG .. 'markRead', 'Mark read')
        set_text(LANG .. 'pmSent', 'Message sent')
        set_text(LANG .. 'cantBlockAdmin', 'You can\'t block admins.')
        set_text(LANG .. 'userBlocked', 'User blocked.')
        set_text(LANG .. 'userUnblocked', 'User unblocked.')
        set_text(LANG .. 'contactListSent', 'I\'ve sent you the contactlist in the requested format.')
        set_text(LANG .. 'removedFromContacts', ' removed from contacts.')
        set_text(LANG .. 'addedToContacts', ' added to contacts.')
        set_text(LANG .. 'contactMissing', 'I haven\'t got your phone number!')
        set_text(LANG .. 'chatListSent', 'I\'ve sent you the dialoglist in the requested format.')
        set_text(LANG .. 'gbansSync', 'GBanlist sync completed.')
        set_text(LANG .. 'longidUpdate', 'Update long_ID.')
        set_text(LANG .. 'alreadyLog', 'Already a log group.')
        set_text(LANG .. 'notLog', 'Not a log group.')
        set_text(LANG .. 'backupDone', 'Backup finished, I\'m sending you the log.')

        -- anti_spam.lua --
        set_text(LANG .. 'blockedForSpam', ' blocked (SPAM).')
        set_text(LANG .. 'floodNotAdmitted', 'Flooding is not admitted.\n')
        set_text(LANG .. 'statusRemoved', 'User kicked.')
        set_text(LANG .. 'gbannedFrom', ' globally banned from ')

        -- arabic_lock.lua --
        set_text(LANG .. 'arabicNotAllowed', 'Arabic/Persian is not admitted.\n')
        set_text(LANG .. 'statusRemovedMsgDeleted', 'User kicked/Message deleted.')

        -- banhammer.lua --
        set_text(LANG .. 'noUsernameFound', 'Can\'t find a user with that username.')

        -- bot.lua --
        set_text(LANG .. 'botOn', 'I\'m back. 😏')
        set_text(LANG .. 'botOff', 'Nothing to do here. 🚀')

        -- feedback.lua --
        set_text(LANG .. 'feedStart', '@EricSolinas you received a feedback: #newfeedback\n\nSender')
        set_text(LANG .. 'feedName', '\nName: ')
        set_text(LANG .. 'feedSurname', '\nSurname: ')
        set_text(LANG .. 'feedUsername', '\nUsername: @')
        set_text(LANG .. 'feedSent', 'Feedback sent!')

        -- filemanager.lua --
        set_text(LANG .. 'backHomeFolder', 'You\'re in the base folder: ')
        set_text(LANG .. 'youAreHere', 'You are here: ')
        set_text(LANG .. 'folderCreated', 'Folder \'X\' created.')
        set_text(LANG .. 'folderDeleted', 'Folder \'X\' deleted.')
        set_text(LANG .. 'fileCreatedWithContent', ' created with \'X\' as contents.')
        set_text(LANG .. 'copiedTo', ' copied to ')
        set_text(LANG .. 'movedTo', ' moved to ')
        set_text(LANG .. 'sendingYou', 'I\'m sending ')
        set_text(LANG .. 'useQuoteOnFile', 'Use \'reply\' on the file you want me to download.')
        set_text(LANG .. 'needMedia', 'I need a file.')
        set_text(LANG .. 'fileDownloadedTo', 'File downloaded to: ')
        set_text(LANG .. 'errorDownloading', 'Error downloading: ')

        -- flame.lua --
        set_text(LANG .. 'cantFlameHigher', 'You can\'t flame mod/owner/admin/sudo/!')
        set_text(LANG .. 'noAutoFlame', 'I can\'t flame myself you jerk!')
        set_text(LANG .. 'hereIAm', 'Here I am!')
        set_text(LANG .. 'stopFlame', 'Yeah I\'m done, holy shit.')
        set_text(LANG .. 'flaming', 'I\'m flaming: ')
        set_text(LANG .. 'errorParameter', 'Redis variable missing.')

        -- help.lua --
        set_text(LANG .. 'require_higher', '🚫 This plugin requires higher privileges.\n')
        set_text(LANG .. 'pluginListStart', 'ℹ️Plugins list: \n\n')
        set_text(LANG .. 'helpInfo', 'ℹ️Write "!help <plugin_name>|<plugin_number>" for more info on that plugin.\nℹ️Or "!helpall" to have all commands.')
        set_text(LANG .. 'errorNoPlugin', 'This plugin doesn\'t exist or doesn\'t have a description.')
        set_text(LANG .. 'doYourBusiness', 'Do your business!')
        set_text(LANG .. 'helpIntro', 'Every \'#\' can be replaced with \'/\' or \'!\'.\nAll commands are Case Insensitive.\nSquare brackets means that is an optional.\nRound brackets with \'|\' means that\'s a choice".\n\n')
        set_text(LANG .. 'youTried', 'You tried it, you won\'t read an help higher than the one you deserve, asshole.')

        -- groups --
        set_text(LANG .. 'newDescription', 'New description:\n')
        set_text(LANG .. 'noDescription', 'No description available.')
        set_text(LANG .. 'description', 'Chat description: ')
        set_text(LANG .. 'newRules', 'New rules:\n')
        set_text(LANG .. 'noRules', 'No rules available.')
        set_text(LANG .. 'rules', 'Chat rules: ')
        set_text(LANG .. 'sendNewGroupPic', 'Send the new group picture.')
        set_text(LANG .. 'photoSaved', 'Picture saved.')
        set_text(LANG .. 'groupSettings', 'Group settings: ')
        set_text(LANG .. 'supergroupSettings', 'Supergroup settings: ')
        set_text(LANG .. 'noGroups', 'No groups at the moment.')
        set_text(LANG .. 'errorFloodRange', 'Error, range is [3-200]')
        set_text(LANG .. 'floodSet', 'Flood set to ')
        set_text(LANG .. 'noOwnerCallAdmin', 'No owner, contact an admin to set one.')
        set_text(LANG .. 'ownerIs', 'Group owner is ')
        set_text(LANG .. 'errorCreateLink', 'Error, can\'t create link.\nI\'m not the owner.')
        set_text(LANG .. 'errorCreateSuperLink', 'Error, can\'t create link.\nI\'m not the owner.\n\nIf you have the link use /setlink to set it')
        set_text(LANG .. 'createLinkInfo', 'Create a link using /newlink.')
        set_text(LANG .. 'linkCreated', 'New link created.')
        set_text(LANG .. 'groupLink', 'Link\n')
        set_text(LANG .. 'adminListStart', 'Admins:\n')
        set_text(LANG .. 'alreadyMod', ' is already a mod.')
        set_text(LANG .. 'promoteMod', ' has been promoted to mod.')
        set_text(LANG .. 'notMod', ' is not a mod.')
        set_text(LANG .. 'demoteMod', ' has been demoted from mod.')
        set_text(LANG .. 'noGroupMods', 'No mod in this group.')
        set_text(LANG .. 'modListStart', 'Mods of ')
        set_text(LANG .. 'muteUserAdd', ' added to muted users list.')
        set_text(LANG .. 'muteUserRemove', ' removed from muted users list.')
        set_text(LANG .. 'modlistCleaned', 'Mod list cleaned.')
        set_text(LANG .. 'rulesCleaned', 'Rules cleaned.')
        set_text(LANG .. 'descriptionCleaned', 'Description cleaned.')
        set_text(LANG .. 'mutelistCleaned', 'Mute list cleaned.')

        -- info.lua --
        set_text(LANG .. 'info', 'INFO')
        set_text(LANG .. 'youAre', '\nYou are')
        set_text(LANG .. 'name', '\nName: ')
        set_text(LANG .. 'surname', '\nSurname: ')
        set_text(LANG .. 'username', '\nUsername: ')
        set_text(LANG .. 'phone', '\nPhone: ')
        set_text(LANG .. 'rank', '\nRank: ')
        set_text(LANG .. 'date', '\nDate: ')
        set_text(LANG .. 'totalMessages', '\nTotal messages: ')
        set_text(LANG .. 'youAreWriting', '\n\nYou are writing to')
        set_text(LANG .. 'groupName', '\nGroup name: ')
        set_text(LANG .. 'members', '\nMembers: ')
        set_text(LANG .. 'supergroupName', '\nSupergroup name: ')
        set_text(LANG .. 'infoFor', 'Info for: ')
        set_text(LANG .. 'users', '\nUsers: ')
        set_text(LANG .. 'admins', '\nAdmins: ')
        set_text(LANG .. 'kickedUsers', '\nKicked users: ')
        set_text(LANG .. 'userInfo', 'User info:')

        -- ingroup.lua --
        set_text(LANG .. 'welcomeNewRealm', 'Welcome to your new realm.')
        set_text(LANG .. 'realmIs', 'This is a realm.')
        set_text(LANG .. 'realmAdded', 'Realm has been added.')
        set_text(LANG .. 'realmAlreadyAdded', 'Realm is already added.')
        set_text(LANG .. 'realmRemoved', 'Realm has been removed.')
        set_text(LANG .. 'realmNotAdded', 'Realm not added.')
        set_text(LANG .. 'errorAlreadyRealm', 'Error, already a realm.')
        set_text(LANG .. 'errorNotRealm', 'Error, not a realm.')
        set_text(LANG .. 'promotedOwner', 'You\'ve been promoted as owner.')
        set_text(LANG .. 'groupIs', 'This is a group.')
        set_text(LANG .. 'groupAlreadyAdded', 'Group is already added.')
        set_text(LANG .. 'groupAddedOwner', 'Group has been added and you\'ve been promoted as owner.')
        set_text(LANG .. 'groupRemoved', 'Group has been removed.')
        set_text(LANG .. 'groupNotAdded', 'Group not added.')
        set_text(LANG .. 'errorAlreadyGroup', 'Error, already a group.')
        set_text(LANG .. 'errorNotGroup', 'Error, not a group.')
        set_text(LANG .. 'noAutoDemote', 'You can\'t demote yourself.')

        -- inpm.lua --
        set_text(LANG .. 'none', 'No one')
        set_text(LANG .. 'groupsJoin', 'Groups:\nUse /join <group_id> to join\n\n')
        set_text(LANG .. 'realmsJoin', 'Realm:\nUse /join <realm_id> to join\n\n')
        set_text(LANG .. 'youGbanned', 'You are globally banned.')
        set_text(LANG .. 'youBanned', 'You are banned.')
        set_text(LANG .. 'chatNotFound', 'Chat not found.')
        set_text(LANG .. 'privateGroup', 'Private group.')
        set_text(LANG .. 'addedTo', 'You\'ve been added to: ')
        set_text(LANG .. 'supportAdded', 'Support added ')
        set_text(LANG .. 'adminAdded', 'Admin added ')
        set_text(LANG .. 'toChat', ' to 👥 ')
        set_text(LANG .. 'aliasSaved', 'Alias saved.')
        set_text(LANG .. 'aliasDeleted', 'Alias deleted.')
        set_text(LANG .. 'noAliasFound', 'No group with that alias.')

        -- inrealm.lua --
        set_text(LANG .. 'realm', 'Realm ')
        set_text(LANG .. 'group', 'Groups ')
        set_text(LANG .. 'created', ' created.')
        set_text(LANG .. 'chatTypeNotFound', 'Chat type not found.')
        set_text(LANG .. 'usersIn', 'Users in ')
        set_text(LANG .. 'alreadyAdmin', ' is already admin.')
        set_text(LANG .. 'promoteAdmin', ' has been promoted to admin.')
        set_text(LANG .. 'notAdmin', ' is not admin.')
        set_text(LANG .. 'demoteAdmin', ' has been demoted from admin.')
        set_text(LANG .. 'groupListStart', 'Groups:\n')
        set_text(LANG .. 'noRealms', 'No realm at the moment.')
        set_text(LANG .. 'realmListStart', 'Realms:\n')
        set_text(LANG .. 'inGroup', ' in this group')
        set_text(LANG .. 'supportRemoved', ' has been removed from support team.')
        set_text(LANG .. 'supportAdded', ' has been added to support team.')
        set_text(LANG .. 'logAlreadyYes', 'Log group already enabled.')
        set_text(LANG .. 'logYes', 'Log group enabled.')
        set_text(LANG .. 'logAlreadyNo', 'Log group already disabled.')
        set_text(LANG .. 'logNo', 'Log group disabled.')
        set_text(LANG .. 'descriptionSet', 'Description set for: ')
        set_text(LANG .. 'errorGroup', 'Error, group ')
        set_text(LANG .. 'errorRealm', 'Error, realm ')
        set_text(LANG .. 'notFound', ' not found')
        set_text(LANG .. 'chat', 'Chat ')
        set_text(LANG .. 'removed', ' removed')
        set_text(LANG .. 'groupListCreated', 'Group list created.')
        set_text(LANG .. 'realmListCreated', 'Realm list created.')

        -- invite.lua --
        set_text(LANG .. 'userBanned', 'User is banned.')
        set_text(LANG .. 'userGbanned', 'User is globally banned.')
        set_text(LANG .. 'privateGroup', 'Group is private.')

        -- locks --
        set_text(LANG .. 'nameLock', '\nLock name: ')
        set_text(LANG .. 'nameAlreadyLocked', 'Name already locked.')
        set_text(LANG .. 'nameLocked', 'Name locked.')
        set_text(LANG .. 'nameAlreadyUnlocked', 'Name already unlocked.')
        set_text(LANG .. 'nameUnlocked', 'Name unlocked.')
        set_text(LANG .. 'photoLock', '\nLock photo: ')
        set_text(LANG .. 'photoAlreadyLocked', 'Photo already locked.')
        set_text(LANG .. 'photoLocked', 'Photo locked.')
        set_text(LANG .. 'photoAlreadyUnlocked', 'Photo already unlocked.')
        set_text(LANG .. 'photoUnlocked', 'Photo unlocked.')
        set_text(LANG .. 'membersLock', '\nLock members: ')
        set_text(LANG .. 'membersAlreadyLocked', 'Members already locked.')
        set_text(LANG .. 'membersLocked', 'Members locked.')
        set_text(LANG .. 'membersAlreadyUnlocked', 'Members already unlocked.')
        set_text(LANG .. 'membersUnlocked', 'Members unlocked.')
        set_text(LANG .. 'leaveLock', '\nLock leave: ')
        set_text(LANG .. 'leaveAlreadyLocked', 'Leave already locked.')
        set_text(LANG .. 'leaveLocked', 'Leave locked.')
        set_text(LANG .. 'leaveAlreadyUnlocked', 'Leave already unlocked.')
        set_text(LANG .. 'leaveUnlocked', 'Leave unlocked.')
        set_text(LANG .. 'spamLock', '\nLock spam: ')
        set_text(LANG .. 'spamAlreadyLocked', 'Spam already locked.')
        set_text(LANG .. 'spamLocked', 'Spam locked.')
        set_text(LANG .. 'spamAlreadyUnlocked', 'Spam already unlocked.')
        set_text(LANG .. 'spamUnlocked', 'Spam unlocked.')
        set_text(LANG .. 'floodSensibility', '\nFlood sensibility: ')
        set_text(LANG .. 'floodUnlockOwners', 'Only owners can unlock flood.')
        set_text(LANG .. 'floodLock', '\nLock flood: ')
        set_text(LANG .. 'floodAlreadyLocked', 'Flood already locked.')
        set_text(LANG .. 'floodLocked', 'Flood locked.')
        set_text(LANG .. 'floodAlreadyUnlocked', 'Flood already unlocked.')
        set_text(LANG .. 'floodUnlocked', 'Flood unlocked.')
        set_text(LANG .. 'arabicLock', '\nLock arabic: ')
        set_text(LANG .. 'arabicAlreadyLocked', 'Arabic already locked.')
        set_text(LANG .. 'arabicLocked', 'Arabic locked.')
        set_text(LANG .. 'arabicAlreadyUnlocked', 'Arabic already unlocked.')
        set_text(LANG .. 'arabicUnlocked', 'Arabic unlocked.')
        set_text(LANG .. 'botsLock', '\nLock bots: ')
        set_text(LANG .. 'botsAlreadyLocked', 'Bots already locked.')
        set_text(LANG .. 'botsLocked', 'Bots locked.')
        set_text(LANG .. 'botsAlreadyUnlocked', 'Bots already unlocked.')
        set_text(LANG .. 'botsUnlocked', 'Bots unlocked.')
        set_text(LANG .. 'linksLock', '\nLock links: ')
        set_text(LANG .. 'linksAlreadyLocked', 'Links already locked.')
        set_text(LANG .. 'linksLocked', 'Links locked.')
        set_text(LANG .. 'linksAlreadyUnlocked', 'Links already unlocked.')
        set_text(LANG .. 'linksUnlocked', 'Links unlocked.')
        set_text(LANG .. 'rtlLock', '\nLock RTL: ')
        set_text(LANG .. 'rtlAlreadyLocked', 'RTL characters already locked già vietati.')
        set_text(LANG .. 'rtlLocked', 'RTL characters locked.')
        set_text(LANG .. 'rtlAlreadyUnlocked', 'RTL characters already unlocked.')
        set_text(LANG .. 'rtlUnlocked', 'RTL characters unlocked.')
        set_text(LANG .. 'tgserviceLock', '\nLock service messages: ')
        set_text(LANG .. 'tgserviceAlreadyLocked', 'Service messages already locked.')
        set_text(LANG .. 'tgserviceLocked', 'Service messages locked.')
        set_text(LANG .. 'tgserviceAlreadyUnlocked', 'Service messages already unlocked.')
        set_text(LANG .. 'tgserviceUnlocked', 'Service messages unlocked.')
        set_text(LANG .. 'stickersLock', '\nLock stickers: ')
        set_text(LANG .. 'stickersAlreadyLocked', 'Stickers already locked.')
        set_text(LANG .. 'stickersLocked', 'Stickers locked.')
        set_text(LANG .. 'stickersAlreadyUnlocked', 'Stickers already unlocked.')
        set_text(LANG .. 'stickersUnlocked', 'Stickers unlocked.')
        set_text(LANG .. 'public', '\nPublic: ')
        set_text(LANG .. 'publicAlreadyYes', 'Group already public.')
        set_text(LANG .. 'publicYes', 'Public group.')
        set_text(LANG .. 'publicAlreadyNo', 'Group already private.')
        set_text(LANG .. 'publicNo', 'Private group.')
        set_text(LANG .. 'contactsAlreadyLocked', 'Contacts already locked.')
        set_text(LANG .. 'contactsLocked', 'Contacts locked.')
        set_text(LANG .. 'contactsAlreadyUnlocked', 'Contacts already unlocked.')
        set_text(LANG .. 'contactsUnlocked', 'Contacts unlocked.')
        set_text(LANG .. 'strictrules', '\nStrict rules: ')
        set_text(LANG .. 'strictrulesAlreadyLocked', 'Strict rules already enabled.')
        set_text(LANG .. 'strictrulesLocked', 'Strict rules enabled.')
        set_text(LANG .. 'strictrulesAlreadyUnlocked', 'Strict rules already disabled.')
        set_text(LANG .. 'strictrulesUnlocked', 'Strict rules disabled.')

        -- onservice.lua --
        set_text(LANG .. 'notMyGroup', 'This is not one of my groups, bye.')

        -- owners.lua --
        set_text(LANG .. 'notTheOwner', 'You are not the owner of this group.')
        set_text(LANG .. 'noAutoUnban', 'You can\'t unban yourself.')

        -- plugins.lua --
        set_text(LANG .. 'enabled', ' enabled.')
        set_text(LANG .. 'disabled', ' disabled.')
        set_text(LANG .. 'alreadyEnabled', ' already enabled.')
        set_text(LANG .. 'alreadyDisabled', ' already disabled.')
        set_text(LANG .. 'notExists', ' not exists.')
        set_text(LANG .. 'systemPlugin', '⛔️ You can\'t disable this plugin because is a system one.')
        set_text(LANG .. 'disabledOnChat', ' disabled on chat.')
        set_text(LANG .. 'noDisabledPlugin', '❔ No plugins disabled on chat.')
        set_text(LANG .. 'pluginNotDisabled', '✔️ This plugin is not disabled on chat.')
        set_text(LANG .. 'pluginEnabledAgain', ' enabled on chat again.')
        set_text(LANG .. 'pluginsReloaded', '💊 Plugins reloaded.')

        -- pokedex.lua --
        set_text(LANG .. 'noPoke', 'No pokémon found.')
        set_text(LANG .. 'pokeName', 'Name: ')
        set_text(LANG .. 'pokeWeight', 'Weight: ')
        set_text(LANG .. 'pokeHeight', 'Height: ')

        -- ruleta.lua --
        set_text(LANG .. 'alreadySignedUp', 'You\'re already registered, use /ruleta to die.')
        set_text(LANG .. 'signedUp', 'You\'ve been registered, have a nice death.')
        set_text(LANG .. 'notSignedUp', 'You\'re not registered.')
        set_text(LANG .. 'ruletaDeleted', 'You\'ve been deleted from the game.')
        set_text(LANG .. 'requireSignUp', 'Before dying you need to be registered, use /registrami.')
        set_text(LANG .. 'groupAlreadySignedUp', 'Group already registered.')
        set_text(LANG .. 'groupSignedUp', 'Group registered with default values (cylinder capacity: 6 bullets: 1).')
        set_text(LANG .. 'ruletaGroupDeleted', 'Group disabled for ruleta.')
        set_text(LANG .. 'requireGroupSignUp', 'Before playing the group must be registered.')
        set_text(LANG .. 'requirePoints', 'Require at least 11 points.')
        set_text(LANG .. 'requireZeroPoints', 'You can\'t be deleted with a score < 0.')
        set_text(LANG .. 'challenge', 'CHALLENGE')
        set_text(LANG .. 'challenger', 'Challenger: ')
        set_text(LANG .. 'challenged', 'Challenged: ')
        set_text(LANG .. 'challengeModTerminated', 'Challenge terminated by mod.')
        set_text(LANG .. 'challengeRejected', 'Challenged rejected challenge, coward!')
        set_text(LANG .. 'cantChallengeYourself', 'You can\'t start a challenge with yourself.')
        set_text(LANG .. 'cantChallengeMe', 'You can\'t start a challenge with me, you would lose it.')
        set_text(LANG .. 'notAccepted', 'Not accepted yet.')
        set_text(LANG .. 'accepted', 'Ongoing.')
        set_text(LANG .. 'roundsLeft', 'Rounds Left: ')
        set_text(LANG .. 'shotsLeft', 'Shots Left: ')
        set_text(LANG .. 'notYourTurn', 'Not your turn.')
        set_text(LANG .. 'yourTurn', ' it\'s your turn.')
        set_text(LANG .. 'challengeEnd', 'Dead, Challenge finished.')
        set_text(LANG .. 'noChallenge', 'No ongoing challenge.')
        set_text(LANG .. 'errorOngoingChallenge', 'Can\'t start multiple challenges at the same time.')
        set_text(LANG .. 'challengeSet', 'Challenge started, challenged can accept with /accetta or reject with /rifiuta.')
        set_text(LANG .. 'wrongPlayer', 'You\'re not the challenged.')
        set_text(LANG .. 'capsChanged', 'Bullets in gun: ')
        set_text(LANG .. 'challengeCapsChanged', 'Bullets in challenge gun: ')
        set_text(LANG .. 'cylinderChanged', 'New cylinder capacity: ')
        set_text(LANG .. 'challengeCylinderChanged', 'New challenge cylinder capacity: ')
        set_text(LANG .. 'errorCapsRange', 'Error, range is [1-X].')
        set_text(LANG .. 'errorCylinderRange', 'Error, range is [5-10].')
        set_text(LANG .. 'cylinderCapacity', 'Cylinder capacity: ')
        set_text(LANG .. 'challengeCylinderCapacity', 'Challenge cylinder capacity: ')
        set_text(LANG .. 'capsNumber', 'Bullets: ')
        set_text(LANG .. 'challengeCapsNumber', 'Challenge bullets: ')
        set_text(LANG .. 'deaths', 'Deaths: ')
        set_text(LANG .. 'duels', 'Challenges: ')
        set_text(LANG .. 'wonduels', 'Won challenges: ')
        set_text(LANG .. 'lostduels', 'Lost challenges: ')
        set_text(LANG .. 'actualstreak', 'Actual streak: ')
        set_text(LANG .. 'longeststreak', 'Longest streak: ')
        set_text(LANG .. 'attempts', 'Total attempts: ')
        set_text(LANG .. 'score', 'Score: ')
        set_text(LANG .. 'cheating', 'Cheat used.')
        set_text(LANG .. 'scoreLeaderboard', 'Score leaderboard\n')

        -- set.lua --
        set_text(LANG .. 'saved', ' saved.')
        set_text(LANG .. 'sendMedia', 'Send me the media you want to save (audio or picture).')
        set_text(LANG .. 'cancelled', 'Cancelled.')
        set_text(LANG .. 'nothingToSet', 'Nothing to set.')
        set_text(LANG .. 'mediaSaved', 'Media saved.')

        -- spam.lua --
        set_text(LANG .. 'msgSet', 'Message set.')
        set_text(LANG .. 'msgsToSend', 'Messages to send: ')
        set_text(LANG .. 'timeBetweenMsgs', 'Time between every message: X seconds.')
        set_text(LANG .. 'msgNotSet', 'You haven\'t set the message, use /setspam.')

        -- stats.lua --
        set_text(LANG .. 'usersInChat', 'Users on chat\n')
        set_text(LANG .. 'groups', '\nGroups: ')

        -- strings.lua --
        set_text(LANG .. 'langUpdate', 'ℹ️ Strings updated.')

        -- supergroup.lua --
        set_text(LANG .. 'makeBotAdmin', 'Promote me as administrator!')
        set_text(LANG .. 'groupIs', 'This is a group.')
        set_text(LANG .. 'supergroupAlreadyAdded', 'Supergroup already added.')
        set_text(LANG .. 'errorAlreadySupergroup', 'Error, already a supergroup.')
        set_text(LANG .. 'supergroupAdded', 'Supergroup has been added.')
        set_text(LANG .. 'supergroupRemoved', 'Supergroup has been removed.')
        set_text(LANG .. 'supergroupNotAdded', 'Supergroup not added.')
        set_text(LANG .. 'membersOf', 'Members of ')
        set_text(LANG .. 'membersKickedFrom', 'Members kicked from ')
        set_text(LANG .. 'cantKickOtherAdmin', 'You can\'t kick other admins.')
        set_text(LANG .. 'promoteSupergroupMod', ' has been promoted to administrator (telegram).')
        set_text(LANG .. 'demoteSupergroupMod', ' has been demoted from administrator (telegram).')
        set_text(LANG .. 'alreadySupergroupMod', ' is already an administrator (telegram).')
        set_text(LANG .. 'notSupergroupMod', ' is not an administrator (telegram).')
        set_text(LANG .. 'cantDemoteOtherAdmin', 'You can\'t demote other admins.')
        set_text(LANG .. 'leftKickme', 'Left using /kickme.')
        set_text(LANG .. 'setOwner', ' is the owner.')
        set_text(LANG .. 'inThisSupergroup', ' in this supergroup.')
        set_text(LANG .. 'sendLink', 'Send me the group link.')
        set_text(LANG .. 'linkSaved', 'New link set.')
        set_text(LANG .. 'supergroupUsernameChanged', 'Supergroup username changed.')
        set_text(LANG .. 'errorChangeUsername', 'Error changing username.\nIt could be already in use.\n\nYou can use letters numbers and underscore.\nMinimum length 5 characters.')
        set_text(LANG .. 'usernameCleaned', 'Supergroup username cleaned.')
        set_text(LANG .. 'errorCleanedUsername', 'Error while cleaning supergroup username.')

        -- unset.lua --
        set_text(LANG .. 'deleted', ' deleted.')

        -- warn.lua --
        set_text(LANG .. 'errorWarnRange', 'Error, range is [1-10].')
        set_text(LANG .. 'warnSet', 'Warn has been set to ')
        set_text(LANG .. 'noWarnSet', 'Warn hasn\t been set yet.')
        set_text(LANG .. 'cantWarnHigher', 'You can\'t warn mod/owner/admin/sudo!')
        set_text(LANG .. 'warned', 'You\'ve been warned X times, calm down!')
        set_text(LANG .. 'unwarned', 'One warn has been deleted, keep it up!')
        set_text(LANG .. 'alreadyZeroWarnings', 'You\'re already at zero warns.')
        set_text(LANG .. 'zeroWarnings', 'Your warns has been removed.')
        set_text(LANG .. 'yourWarnings', 'You\'re at X warns on Y.')

        -- welcome.lua --
        set_text(LANG .. 'newWelcome', 'New welcome message:\n')
        set_text(LANG .. 'newWelcomeNumber', 'Welcome message will be sent every X members.')
        set_text(LANG .. 'noSetValue', 'No value set.')

        -- whitelist.lua --
        set_text(LANG .. 'userBot', 'User/Bot ')
        set_text(LANG .. 'whitelistRemoved', ' removed from whitelist.')
        set_text(LANG .. 'whitelistAdded', ' added to whitelist.')
        set_text(LANG .. 'whitelistCleaned', 'Whitelist cleaned.')

        ------------
        -- Usages --
        ------------
        -- administrator.lua --
        set_text(LANG .. 'administrator:0', 20)
        set_text(LANG .. 'administrator:1', 'ADMIN')
        set_text(LANG .. 'administrator:2', '(#pm|sasha messaggia) <user_id> <msg>: Sasha writes <msg> to <user_id>.')
        set_text(LANG .. 'administrator:3', '#import <group_link>: Sasha joins <group_link>.')
        set_text(LANG .. 'administrator:4', '(#block|sasha blocca) <user_id>: Sasha blocks <user_id>.')
        set_text(LANG .. 'administrator:5', '(#unblock|sasha sblocca) <user_id>: Sasha unblocks <user_id>.')
        set_text(LANG .. 'administrator:6', '(#markread|sasha segna letto) (on|off): Sasha marks as [not] read messages that receives.')
        set_text(LANG .. 'administrator:7', '(#setbotphoto|sasha cambia foto): Sasha waits for a pic to set as bot\'s profile.')
        set_text(LANG .. 'administrator:8', '(#updateid|sasha aggiorna longid): Sasha saves long_id.')
        set_text(LANG .. 'administrator:9', '(#addlog|sasha aggiungi log): Sasha adds log.')
        set_text(LANG .. 'administrator:10', '(#remlog|sasha rimuovi log): Sasha removes log.')
        set_text(LANG .. 'administrator:11', 'SUDO')
        set_text(LANG .. 'administrator:12', '(#contactlist|sasha lista contatti) (txt|json): Sasha sends contacts list.')
        set_text(LANG .. 'administrator:13', '(#dialoglist|sasha lista chat) (txt|json): Sasha sends chats list.')
        set_text(LANG .. 'administrator:14', '(#addcontact|sasha aggiungi contatto) <phone> <name> <surname>: Sasha adds specified contact.')
        set_text(LANG .. 'administrator:15', '(#delcontact|sasha elimina contatto) <user_id>: Sasha deletes contact of <user_id>.')
        set_text(LANG .. 'administrator:16', '(#sendcontact|sasha invia contatto) <phone> <name> <surname>: Sasha sends contact with specified information.')
        set_text(LANG .. 'administrator:17', '(#mycontact|sasha mio contatto): Sasha sends sender contact.')
        set_text(LANG .. 'administrator:18', '(#sync_gbans|sasha sincronizza superban): Sasha syncs gbans list with the one offered by TeleSeed.')
        set_text(LANG .. 'administrator:19', '(#backup|sasha esegui backup): Sasha makes a backup of herself and sends log to the sender.')
        set_text(LANG .. 'administrator:20', '#vardump [<reply>|<msg_id>]: Sasha sends vardump of specified message.')

        -- anti_spam.lua --
        set_text(LANG .. 'anti_spam:0', 1)
        set_text(LANG .. 'anti_spam:1', 'Sasha kicks user that was flooding.')

        -- apod.lua --
        set_text(LANG .. 'apod:0', 4)
        set_text(LANG .. 'apod:1', '#(apod|astro) [<date>]: Sasha sends APOD.')
        set_text(LANG .. 'apod:2', '#(apod|astro)hd [<date>]: Sasha sends APOD in HD.')
        set_text(LANG .. 'apod:3', '#(apod|astro)text [<date>]: Sasha sends explanation of the APOD.')
        set_text(LANG .. 'apod:4', 'If <date> is specified and it\'s in this format AAAA-MM-GG the APOD refers to <date>.')

        -- arabic_lock.lua --
        set_text(LANG .. 'arabic_lock:0', 1)
        set_text(LANG .. 'arabic_lock:1', 'Sasha blocks arabic in groups.')

        -- banhammer.lua --
        set_text(LANG .. 'banhammer:0', 13)
        set_text(LANG .. 'banhammer:1', '(#kickme|sasha uccidimi): Sasha kicks sender.')
        set_text(LANG .. 'banhammer:2', 'MOD')
        set_text(LANG .. 'banhammer:3', '(#kick|spara|[sasha] uccidi) <id>|<username>|<reply>: Sasha kicks specified user.')
        set_text(LANG .. 'banhammer:4', '(#ban|esplodi|kaboom|[sasha] banna|[sasha] decompila) <id>|<username>|<reply>: Sasha kicks and bans specified user, if he tries to join again it\'s automatically kicked.')
        set_text(LANG .. 'banhammer:5', '(#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>: Sasha unbans specified user.')
        set_text(LANG .. 'banhammer:6', '(#banlist|[sasha] lista ban) [<group_id>]: Sasha sends bans list of the group or of <group_id>.')
        set_text(LANG .. 'banhammer:7', 'OWNER')
        set_text(LANG .. 'banhammer:8', '(#kicknouser|[sasha] uccidi nouser|spara nouser): Sasha kicks users without username.')
        set_text(LANG .. 'banhammer:9', '(#kickinactive [<msgs>]|((sasha uccidi)|spara sotto <msgs> messaggi)): Sasha kicks inactive users under <msgs> messages.')
        set_text(LANG .. 'banhammer:10', 'SUPPORT')
        set_text(LANG .. 'banhammer:11', '(#gban|[sasha] superbanna) <id>|<username>|<reply>: Sasha kicks and gbans specified user, if he tries to join again it\'s automatically kicked.')
        set_text(LANG .. 'banhammer:12', '(#ungban|[sasha] supersbanna) <id>|<username>|<reply>: Sasha ungbans specified user.')
        set_text(LANG .. 'banhammer:13', '(#gbanlist|[sasha] lista superban): Sasha sends gbans list.')

        -- bot.lua --
        set_text(LANG .. 'bot:0', 2)
        set_text(LANG .. 'bot:1', 'OWNER')
        set_text(LANG .. 'bot:2', '#bot|sasha on|off: Sasha goes on|off on the group.')

        -- broadcast.lua --
        set_text(LANG .. 'broadcast:0', 4)
        set_text(LANG .. 'broadcast:1', 'ADMIN')
        set_text(LANG .. 'broadcast:2', '#br <group_id> <text>: Sasha sends <text> to <group_id>.')
        set_text(LANG .. 'broadcast:3', 'SUDO')
        set_text(LANG .. 'broadcast:4', '#broadcast <text>: Sasha sends <text> to all groups.')

        -- dogify.lua --
        set_text(LANG .. 'dogify:0', 1)
        set_text(LANG .. 'dogify:1', '(#dogify|[sasha] doge) <your/words/with/slashes>: Sasha creates a pic with doge and specified words.')

        -- duckduckgo.lua --
        set_text(LANG .. 'duckduckgo:0', 1)
        set_text(LANG .. 'duckduckgo:1', '#duck[duck]go <terms>: Sasha searches <terms> on DuckDuckGo.')

        -- echo.lua --
        set_text(LANG .. 'echo:0', 2)
        set_text(LANG .. 'echo:1', 'MOD')
        set_text(LANG .. 'echo:2', '(#echo|sasha ripeti) <text>: Sasha repeat <text>.')

        -- feedback.lua --
        set_text(LANG .. 'feedback:0', 1)
        set_text(LANG .. 'feedback:1', '#feedback <text>: Sasha sends <text> to her creator.')

        -- filemanager.lua --
        set_text(LANG .. 'filemanager:0', 15)
        set_text(LANG .. 'filemanager:1', 'SUDO')
        set_text(LANG .. 'filemanager:2', '#folder: Sasha sends actual directory.')
        set_text(LANG .. 'filemanager:3', '#cd [<directory>]: Sasha enters in <directory>, if it\'s not specified it returns to base folder.')
        set_text(LANG .. 'filemanager:4', '#ls: Sasha sends the list of files and folders of the current directory.')
        set_text(LANG .. 'filemanager:5', '#mkdir <directory>: Sasha creates <directory>.')
        set_text(LANG .. 'filemanager:6', '#rmdir <directory>: Sasha deletes <directory>.')
        set_text(LANG .. 'filemanager:7', '#rm <file>: Sasha deletes <file>.')
        set_text(LANG .. 'filemanager:8', '#touch <file>: Sasha creates <file>.')
        set_text(LANG .. 'filemanager:9', '#cat <file>: Sasha sends <file> content.')
        set_text(LANG .. 'filemanager:10', '#tofile <file> <text>: Sasha creates <file> with <text> as content.')
        set_text(LANG .. 'filemanager:11', '#shell <command>: Sasha executes <command>.')
        set_text(LANG .. 'filemanager:12', '#cp <file> <directory>: Sasha copies <file> in <directory>.')
        set_text(LANG .. 'filemanager:13', '#mv <file> <directory>: Sasha moves <file> in <directory>.')
        set_text(LANG .. 'filemanager:14', '#upload <file>: Sasha uploads <file> on chat.')
        set_text(LANG .. 'filemanager:15', '#download <reply>: Sasha downloads the file in <reply>.')

        -- flame.lua --
        set_text(LANG .. 'flame:0', 4)
        set_text(LANG .. 'flame:1', 'MOD')
        set_text(LANG .. 'flame:2', '(#startflame|[sasha] flamma) <id>|<username>|<reply>: Sasha flames specified user.')
        set_text(LANG .. 'flame:3', '(#stopflame|[sasha] stop flame): Sasha stops flame.')
        set_text(LANG .. 'flame:4', '(#flameinfo|[sasha] info flame): Sasha sends flamed user info.')

        -- get.lua --
        set_text(LANG .. 'get:0', 1)
        set_text(LANG .. 'get:1', '(#getlist|#get|sasha lista): Sasha sends a list of saved variables.')
        set_text(LANG .. 'get:2', '[#get] <var_name>: Sasha sends value of <var_name>.')

        -- google.lua --
        set_text(LANG .. 'google:0', 2)
        set_text(LANG .. 'google:1', '(#google|[sasha] googla) <terms>: Sasha googles <terms>.')

        -- help.lua --
        set_text(LANG .. 'help:0', 5)
        set_text(LANG .. 'help:1', '(#sudolist|sasha lista sudo): Sasha sends sudo list.')
        set_text(LANG .. 'help:2', '(#help|sasha aiuto): Sasha sends a list of plugins.')
        set_text(LANG .. 'help:3', '(#help|commands|sasha aiuto) <plugin_name>|<plugin_number> [<fake_rank>]: Sasha sends help of specified plugin.')
        set_text(LANG .. 'help:4', '(#helpall|allcommands|sasha aiuto tutto) [<fake_rank>]: Sasha sends help of all plugins.')
        set_text(LANG .. 'help:5', '<fake_rank> parameter is necessary to get a help of a lower rank, ranks are: USER, MOD, OWNER, SUPPORT, ADMIN, SUDO.')

        -- info.lua --
        set_text(LANG .. 'info:0', 10)
        set_text(LANG .. 'info:1', '#getrank|rango [<id>|<username>|<reply>]: Sasha sends rank of specified user.')
        set_text(LANG .. 'info:2', '(#info|[sasha] info): Sasha sends user\'s info or chat\'s info or her info.')
        set_text(LANG .. 'info:3', 'MOD')
        set_text(LANG .. 'info:4', '(#info|[sasha] info) <id>|<username>|<reply>|from: Sasha sends info of specified user.')
        set_text(LANG .. 'info:5', '(#who|#members|[sasha] lista membri): Sasha users list.')
        set_text(LANG .. 'info:6', '(#kicked|[sasha] lista rimossi): Sasha sends kicked users list.')
        set_text(LANG .. 'info:7', 'OWNER')
        set_text(LANG .. 'info:8', '(#groupinfo|[sasha] info gruppo) [<group_id>]: Sasha sends info of specified group.')
        set_text(LANG .. 'info:9', 'SUDO')
        set_text(LANG .. 'info:10', '(#database|[sasha] database): Sasha saves all info of all users of group.')

        -- ingroup.lua --
        set_text(LANG .. 'ingroup:0', 32)
        set_text(LANG .. 'ingroup:1', '(#rules|sasha regole): Sasha sends group\'s rules.')
        set_text(LANG .. 'ingroup:2', '(#about|sasha descrizione): Sasha sends group\'s about.')
        set_text(LANG .. 'ingroup:3', '(#modlist|[sasha] lista mod): Sasha sends moderators list.')
        set_text(LANG .. 'ingroup:4', '#owner: Sasha sends owner\'s id.')
        set_text(LANG .. 'ingroup:5', 'MOD')
        set_text(LANG .. 'ingroup:6', '#setname|#setgpname <group_name>: Sasha changes group\'s name with <group_name>.')
        set_text(LANG .. 'ingroup:7', '#setphoto|#setgpphoto: Sasha waits for a pic to set it as group profile pic.')
        set_text(LANG .. 'ingroup:8', '(#setrules|sasha imposta regole) <text>: Sasha changes group\'s rules with <text>.')
        set_text(LANG .. 'ingroup:9', '(#setabout|sasha imposta descrizione) <text>: Sasha changes group\'s about with <text>.')
        set_text(LANG .. 'ingroup:10', '(#lock|[sasha] blocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha locks specified parameter.')
        set_text(LANG .. 'ingroup:11', '(#unlock|[sasha] sblocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts: Sasha unlocks specified parameter.')
        set_text(LANG .. 'ingroup:12', '#muteuser|voce <id>|<username>|<reply>: Sasha [un]mute specified user.')
        set_text(LANG .. 'ingroup:13', '(#muteslist|lista muti): Sasha sends muted parameters list.')
        set_text(LANG .. 'ingroup:14', '(#mutelist|lista utenti muti): Sasha sends muted users list.')
        set_text(LANG .. 'ingroup:15', '#settings: Sasha sends group settings.')
        set_text(LANG .. 'ingroup:16', '#public yes|no: Sasha makes group public|private.')
        set_text(LANG .. 'ingroup:17', '(#newlink|sasha crea link): Sasha creates group\'s link.')
        set_text(LANG .. 'ingroup:18', '(#link|sasha link): Sasha sends group\'s link.')
        set_text(LANG .. 'ingroup:19', '#setflood <value>: Sasha sets <value> as max flood.')
        set_text(LANG .. 'ingroup:20', 'OWNER')
        set_text(LANG .. 'ingroup:21', '(#setlink|[sasha] imposta link): Sasha saves a group\'s link with the one that will be sent.')
        set_text(LANG .. 'ingroup:22', '(#promote|[sasha] promuovi) <username>|<reply>: Sasha promotes to mod specified user.')
        set_text(LANG .. 'ingroup:23', '(#demote|[sasha] degrada) <username>|<reply>: Sasha demotes from mod specified user.')
        set_text(LANG .. 'ingroup:24', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha mute specified parameter.')
        set_text(LANG .. 'ingroup:25', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha unmute specified parameter.')
        set_text(LANG .. 'ingroup:26', '#setowner <id>: Sasha sets <id> as owner.')
        set_text(LANG .. 'ingroup:27', '#clean modlist|rules|about: Sasha cleans specified parameter.')
        set_text(LANG .. 'ingroup:28', 'ADMIN')
        set_text(LANG .. 'ingroup:29', '#add [realm]: Sasha adds group|realm.')
        set_text(LANG .. 'ingroup:30', '#rem [realm]: Sasha removes group|realm.')
        set_text(LANG .. 'ingroup:31', '#kill chat|realm: Sasha kicks every user in group|realm and removes it.')
        set_text(LANG .. 'ingroup:32', '#setgpowner <group_id> <user_id>: Sasha sets <user_id> as owner of <group_id>.')

        -- inpm.lua --
        set_text(LANG .. 'inpm:0', 10)
        set_text(LANG .. 'inpm:1', '#chats: Sasha sends a "public" chats list.')
        set_text(LANG .. 'inpm:2', '#chatlist: Sasha sends a file with "public" chats list.')
        set_text(LANG .. 'inpm:3', 'ADMIN')
        set_text(LANG .. 'inpm:4', '#join <chat_id>|<alias> [support]: Sasha tries to add the sender to <chat_id>|<alias>.')
        set_text(LANG .. 'inpm:5', '#getaliaslist: Sasha sends alias list.')
        set_text(LANG .. 'inpm:6', 'SUDO')
        set_text(LANG .. 'inpm:7', '#allchats: Sasha sends a list of all chats.')
        set_text(LANG .. 'inpm:8', '#allchatlist: Sasha sends a file with a list of all chats.')
        set_text(LANG .. 'inpm:9', '#setalias <alias> <group_id>: Sasha sets <alias> as alias of <group_id>.')
        set_text(LANG .. 'inpm:10', '#unsetalias <alias>: Sasha deletes <alias>.')

        -- inrealm.lua --
        set_text(LANG .. 'inrealm:0', 26)
        set_text(LANG .. 'inrealm:1', 'MOD')
        set_text(LANG .. 'inrealm:2', '#who: Sasha sends a list of all group|realm members.')
        set_text(LANG .. 'inrealm:3', '#wholist: Sasha sends a file with a list of all group/realm members.')
        set_text(LANG .. 'inrealm:4', 'OWNER')
        set_text(LANG .. 'inrealm:5', '#log: Sasha sends a file that contains group/realm log.')
        set_text(LANG .. 'inrealm:6', 'ADMIN')
        set_text(LANG .. 'inrealm:7', '(#creategroup|sasha crea gruppo) <group_name>: Sasha creates a group with specified name.')
        set_text(LANG .. 'inrealm:8', '(#createsuper|sasha crea supergruppo) <group_name>: Sasha creates a supergroup with specified name.')
        set_text(LANG .. 'inrealm:9', '(#createrealm|sasha crea regno) <realm_name>: Sasha creates a realm with specified name.')
        set_text(LANG .. 'inrealm:10', '(#setabout|sasha imposta descrizione) <group_id> <text>: Sasha changes <group_id>\'s about with <text>.')
        set_text(LANG .. 'inrealm:11', '(#setrules|sasha imposta regole) <group_id> <text>: Sasha changes <group_id>\'s rules with <text>.')
        set_text(LANG .. 'inrealm:12', '#setname <realm_name>: Sasha changes realm\'s name with <realm_name>.')
        set_text(LANG .. 'inrealm:13', '#setname|#setgpname <group_id> <group_name>: Sasha changes <group_id>\'s name with <group_name>.')
        set_text(LANG .. 'inrealm:14', '(#lock|[sasha] blocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha locks <group_id>\'s specified setting.')
        set_text(LANG .. 'inrealm:15', '(#unlock|[sasha] sblocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker: Sasha unlocks <group_id>\'s specified setting.')
        set_text(LANG .. 'inrealm:16', '#settings <group_id>: Sasha sends <group_id>\'s settings.')
        set_text(LANG .. 'inrealm:17', '#type: Sasha sends group\'s type.')
        set_text(LANG .. 'inrealm:18', '#kill chat <group_id>: Sasha kicks all members of <group_id> and removes <group_id>.')
        set_text(LANG .. 'inrealm:19', '#kill realm <realm_id>: Sasha kicks all members of <realm_id> and removes <realm_id>.')
        set_text(LANG .. 'inrealm:20', '#rem <group_id>: Sasha removes group.')
        set_text(LANG .. 'inrealm:21', '#support <user_id>|<username>: Sasha promotes specified user to support.')
        set_text(LANG .. 'inrealm:22', '#-support <user_id>|<username>: Sasha demotes specified user from support.')
        set_text(LANG .. 'inrealm:23', '#list admins|groups|realms: Sasha sends list of specified parameter.')
        set_text(LANG .. 'inrealm:24', 'SUDO')
        set_text(LANG .. 'inrealm:25', '#addadmin <user_id>|<username>: Sasha promotes specified user to administrator.')
        set_text(LANG .. 'inrealm:26', '#removeadmin <user_id>|<username>: Sasha demotes specified user from administrator.')

        -- interact.lua --
        set_text(LANG .. 'interact:0', 1)
        set_text(LANG .. 'interact:1', 'Sasha interacts with users.')

        -- invite.lua --
        set_text(LANG .. 'invite:0', 2)
        -- set_text(LANG .. 'invite:1','OWNER')
        set_text(LANG .. 'invite:1', 'ADMIN')
        set_text(LANG .. 'invite:2', '(#invite|[sasha] invita|[sasha] resuscita) <id>|<username>|<reply>: Sasha invites specified user.')

        -- leave_ban.lua --
        set_text(LANG .. 'leave_ban:0', 1)
        set_text(LANG .. 'leave_ban:1', 'Sasha bans leaving users.')

        -- msg_checks.lua --
        set_text(LANG .. 'msg_checks:0', 1)
        set_text(LANG .. 'msg_checks:1', 'Sasha checks received messages.')

        -- onservice.lua --
        set_text(LANG .. 'onservice:0', 2)
        set_text(LANG .. 'onservice:1', 'ADMIN')
        set_text(LANG .. 'onservice:2', '(#leave|sasha abbandona): Sasha leaves group.')

        -- owners.lua --
        set_text(LANG .. 'owners:0', 5)
        -- set_text(LANG .. 'owners:1','#owners <group_id>: Sasha sends <group_id>\'s log.')
        set_text(LANG .. 'owners:1', '#changeabout <group_id> <text>: Sasha changes <group_id>\'s about with <text>.')
        set_text(LANG .. 'owners:2', '#changerules <group_id> <text>: Sasha changes <group_id>\'s rules with <text>.')
        set_text(LANG .. 'owners:3', '#changename <group_id> <text>: Sasha changes <group_id>\'s name with <text>.')
        set_text(LANG .. 'owners:4', '#viewsettings <group_id>: Sasha sends <group_id>\'s settings.')
        set_text(LANG .. 'owners:5', '#loggroup <group_id>: Sasha sends <group_id>\'s log.')

        -- plugins.lua --
        set_text(LANG .. 'plugins:0', 9)
        set_text(LANG .. 'plugins:1', 'OWNER')
        set_text(LANG .. 'plugins:2', '(#disabledlist|([sasha] lista disabilitati|disattivati)): Sasha sends disabled plugins list.')
        set_text(LANG .. 'plugins:3', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> chat: Sasha re enables <plugin> on this chat.')
        set_text(LANG .. 'plugins:4', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> chat: Sasha disables <plugin> on this chat.')
        set_text(LANG .. 'plugins:5', 'SUDO')
        set_text(LANG .. 'plugins:6', '(#plugins|[sasha] lista plugins): Sasha mostra una lista di tutti i plugins.')
        set_text(LANG .. 'plugins:7', '(#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> [chat]: Sasha enables <plugin>, if specified just on chat.')
        set_text(LANG .. 'plugins:8', '(#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> [chat]: Sasha disables <plugin>, if specified just on chat.')
        set_text(LANG .. 'plugins:9', '(#[plugin[s]] reload|[sasha] ricarica): Sasha reloads all plugins.')

        -- pokedex.lua --
        set_text(LANG .. 'pokedex:0', 1)
        set_text(LANG .. 'pokedex:1', '#pokedex|#pokemon <name>|<id>: Sasha searches specified pokemon and sends its info.')

        -- qr.lua --
        set_text(LANG .. 'qr:0', 5)
        set_text(LANG .. 'qr:1', '(#qr|sasha qr) ["<background_color>" "<data_color>"] <text>: Sasha creates QR Code of <text>, if specified it colors QR Code.')
        set_text(LANG .. 'qr:2', 'Colors can be specified as follows:')
        set_text(LANG .. 'qr:3', 'Text => red|green|blue|purple|black|white|gray.')
        set_text(LANG .. 'qr:4', 'Hexadecimal => ("a56729" è marrone).')
        set_text(LANG .. 'qr:5', 'Decimal => ("255-192-203" è rosa).')

        -- reactions.lua --
        set_text(LANG .. 'reactions:0', 2)
        set_text(LANG .. 'reactions:1', 'SUDO')
        set_text(LANG .. 'reactions:2', '#writing on|off: Sasha (pretends|stops pretending) to write.')

        -- ruleta.lua --
        set_text(LANG .. 'ruleta:0', 24)
        set_text(LANG .. 'ruleta:1', 'Ruleta by AISasha, inspired from Leia (#RIP) and Arya. Ruleta is the russian roulette with gun, cylinder and bullets, the cylinder rotates and if there\'s the bullet Sasha kicks you.')
        set_text(LANG .. 'ruleta:2', '#registerme|#registrami: Sasha registers user to the game.')
        set_text(LANG .. 'ruleta:3', '#deleteme|#eliminami: Sasha deletes user from the game.')
        set_text(LANG .. 'ruleta:4', '#ruletainfo: Sasha sends gun\'s info.')
        set_text(LANG .. 'ruleta:5', '#mystats|#punti: Sasha sends user stats.')
        set_text(LANG .. 'ruleta:6', '#ruleta: Sasha tries to kill you.')
        set_text(LANG .. 'ruleta:7', '#godruleta: Sasha gives you 50% to gain 70 points and 50% to lose them all (requires at least 11 points).')
        set_text(LANG .. 'ruleta:8', '#challenge|#sfida <username>|<reply>: Sasha starts a challenge between sender and specified user.')
        set_text(LANG .. 'ruleta:9', '#accept|#accetta: Sasha confirms challenge.')
        set_text(LANG .. 'ruleta:10', '#reject|#rifiuta: Sasha deletes challenge.')
        set_text(LANG .. 'ruleta:11', '#challengeinfo: Sasha sends current challenge info.')
        set_text(LANG .. 'ruleta:12', 'MOD')
        set_text(LANG .. 'ruleta:13', '#setcaps <value>: Sasha puts <value> bullets in cylinder.')
        set_text(LANG .. 'ruleta:14', '#setchallengecaps <value>: Sasha puts <value> bullets in challenge cylinder.')
        set_text(LANG .. 'ruleta:15', '(#kick|spara|[sasha] uccidi) random: Sasha chooses a random user and kicks it.')
        set_text(LANG .. 'ruleta:16', 'OWNER')
        set_text(LANG .. 'ruleta:17', '#setcylinder <value>: Sasha chooses a cylinder with <value> max bullets in the range [5-10].')
        set_text(LANG .. 'ruleta:18', '#setchallengecylinder <value>: Sasha chooses a challenge cylinder with <value> max bullets in the range [5-10].')
        set_text(LANG .. 'ruleta:19', 'ADMIN')
        set_text(LANG .. 'ruleta:20', '#registergroup|#registragruppo: Sasha enables group to play ruleta.')
        set_text(LANG .. 'ruleta:21', '#deletegroup|#eliminagruppo: Sasha disables group to play ruleta.')
        set_text(LANG .. 'ruleta:22', 'SUDO')
        set_text(LANG .. 'ruleta:23', '#createdb: Sasha creates ruleta database.')
        set_text(LANG .. 'ruleta:24', '#addpoints <id> <value>: Sasha adds <value> points to specified user.')

        -- set.lua --
        set_text(LANG .. 'set:0', 4)
        set_text(LANG .. 'set:1', 'MOD')
        set_text(LANG .. 'set:2', '(#set|[sasha] setta) <var_name> <text>: Sasha saves <text> as answer to <var_name>.')
        set_text(LANG .. 'set:3', '(#setmedia|[sasha] setta media) <var_name>: Sasha saves the media (audio or picture) that will be sent as answer to <var_name>.')
        set_text(LANG .. 'set:4', '(#cancel|[sasha] annulla): Sasha cancels #setmedia.')

        -- shout.lua --
        set_text(LANG .. 'shout:0', 2)
        set_text(LANG .. 'shout:1', '(#shout|[sasha] grida|[sasha] urla) <text>: Sasha "shouts" <text>.')

        -- spam.lua --
        set_text(LANG .. 'spam:0', 5)
        set_text(LANG .. 'spam:1', 'OWNER')
        set_text(LANG .. 'spam:2', '#setspam <text>: Sasha sets <text> as the spam message.')
        set_text(LANG .. 'spam:3', '#setmsgs <value>: Sasha sets <value> as number of messages to send.')
        set_text(LANG .. 'spam:4', '#setwait <seconds>: Sasha sets <seconds> as wait between messages.')
        set_text(LANG .. 'spam:5', '(#spam|[sasha] spamma): Sasha starts spamming.')

        -- stats.lua --
        set_text(LANG .. 'stats:0', 8)
        set_text(LANG .. 'stats:1', '[#]aisasha: Sasha sends her description.')
        set_text(LANG .. 'stats:2', 'MOD')
        set_text(LANG .. 'stats:3', '(#stats|#messages): Sasha sends chat\'s stats.')
        set_text(LANG .. 'stats:4', '(#statslist|#messageslist): Sasha sends file with chat\'s stats.')
        set_text(LANG .. 'stats:5', 'ADMIN')
        set_text(LANG .. 'stats:6', '(#stats|#messages) group <group_id>: Sasha sends <group_id>\'s stats.')
        set_text(LANG .. 'stats:7', '(#statslist|#messageslist) group <group_id>: Sasha sends file with <group_id>\'s stats.')
        set_text(LANG .. 'stats:8', '(#stats|#messages) aisasha: Sasha sends her stats.')

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
        set_text(LANG .. 'supergroup:1', '#owner: Sasha sends owner info.')
        set_text(LANG .. 'supergroup:2', '(#modlist|[sasha] lista mod): Sasha moderators list.')
        set_text(LANG .. 'supergroup:3', '(#rules|sasha regole): Sasha sends group rules.')
        set_text(LANG .. 'supergroup:4', 'MOD')
        set_text(LANG .. 'supergroup:5', '(#bots|[sasha] lista bot): Sasha sends bots list.')
        set_text(LANG .. 'supergroup:6', '#wholist|#memberslist: Sasha sends a file with members list.')
        set_text(LANG .. 'supergroup:7', '#kickedlist: Sasha sends a file with kicked users list.')
        set_text(LANG .. 'supergroup:8', '#del <reply>: Sasha deletes specified message.')
        set_text(LANG .. 'supergroup:9', '(#newlink|[sasha] crea link): Sasha creates a new link.')
        set_text(LANG .. 'supergroup:10', '(#link|sasha link): Sasha sends group\'s link.')
        set_text(LANG .. 'supergroup:11', '#setname|setgpname <text>: Sasha changes group\'s name with <text>.')
        set_text(LANG .. 'supergroup:12', '#setphoto|setgpphoto: Sasha will change group\'s picture with the one that will be sent.')
        set_text(LANG .. 'supergroup:13', '(#setrules|sasha imposta regole) <text>: Sasha changes group\'s rules with <text>.')
        set_text(LANG .. 'supergroup:14', '(#setabout|sasha imposta descrizione) <text>: Sasha changes group\'s about with <text>.')
        set_text(LANG .. 'supergroup:15', '(#lock|[sasha] blocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha locks specified parameter.')
        set_text(LANG .. 'supergroup:16', '(#unlock|[sasha] sblocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict: Sasha unlocks specified parameter.')
        set_text(LANG .. 'supergroup:17', '#setflood <value>: Sasha sets <value> as max flood.')
        set_text(LANG .. 'supergroup:18', '#public yes|no: Sasha makes group public|private.')
        set_text(LANG .. 'supergroup:19', '#muteuser|voce <id>|<username>|<reply>: Sasha [un]mute specified user.')
        set_text(LANG .. 'supergroup:20', '(#muteslist|lista muti): Sasha sends muted parameters list.')
        set_text(LANG .. 'supergroup:21', '(#mutelist|lista utenti muti): Sasha sends muted users list.')
        set_text(LANG .. 'supergroup:22', '#settings: Sasha sends group\'s settings.')
        set_text(LANG .. 'supergroup:23', 'OWNER')
        set_text(LANG .. 'supergroup:24', '(#admins|[sasha] lista admin): Sasha sends telegram\'s administrators list.')
        set_text(LANG .. 'supergroup:25', '(#setlink|sasha imposta link): Sasha saves a group\'s link with the one that will be sent.')
        set_text(LANG .. 'supergroup:26', '#setadmin <id>|<username>|<reply>: Sasha promotes specified user to telegram\'s administrator.')
        set_text(LANG .. 'supergroup:27', '#demoteadmin <id>|<username>|<reply>: Sasha demotes specified user from telegram\'s administrator.')
        set_text(LANG .. 'supergroup:28', '#setowner <id>|<username>|<reply>: Sasha sets specified user as the owner.')
        set_text(LANG .. 'supergroup:29', '(#promote|[sasha] promuovi) <id>|<username>|<reply>: Sasha promotes to moderator specified user.')
        set_text(LANG .. 'supergroup:30', '(#demote|[sasha] degrada) <id>|<username>|<reply>: Sasha demotes from moderator specified user.')
        set_text(LANG .. 'supergroup:31', '#clean rules|about|modlist|mutelist: Sasha cleans specified parameter.')
        set_text(LANG .. 'supergroup:32', '#mute|silenzia all|text|documents|gifs|video|photo|audio: Sasha mutes specified parameter.')
        set_text(LANG .. 'supergroup:33', '#unmute|ripristina all|text|documents|gifs|video|photo|audio: Sasha unmutes specified parameter.')
        set_text(LANG .. 'supergroup:34', 'SUPPORT')
        set_text(LANG .. 'supergroup:35', '#add: Sasha adds supergroup.')
        set_text(LANG .. 'supergroup:36', '#rem: Sasha removes supergroup.')
        set_text(LANG .. 'supergroup:37', 'ADMIN')
        set_text(LANG .. 'supergroup:38', '#tosuper: Sasha converts group to supergroup.')
        set_text(LANG .. 'supergroup:39', '#setusername <text>: Sasha changes group\'s username with <text>.')
        set_text(LANG .. 'supergroup:40', 'peer_id')
        set_text(LANG .. 'supergroup:41', 'msg.to.id')
        set_text(LANG .. 'supergroup:42', 'msg.to.peer_id')
        set_text(LANG .. 'supergroup:43', 'SUDO')
        set_text(LANG .. 'supergroup:44', '#mp <id>: Sasha promotes <id> to telegram\'s moderator.')
        set_text(LANG .. 'supergroup:45', '#md <id>: Sasha demotes <id> from telegram\'s moderator.')

        -- tagall.lua --
        set_text(LANG .. 'tagall:0', 2)
        set_text(LANG .. 'tagall:1', 'OWNER')
        set_text(LANG .. 'tagall:2', '(#tagall|sasha tagga tutti) <text>: Sasha tags all group\'s members and writes <text>.')

        -- tex.lua --
        set_text(LANG .. 'tex:0', 1)
        set_text(LANG .. 'tex:1', '(#tex|[sasha] equazione) <equation>: Sasha converts <equation> in image.')

        -- unset.lua --
        set_text(LANG .. 'unset:0', 2)
        set_text(LANG .. 'unset:1', 'MOD')
        set_text(LANG .. 'unset:2', '(#unset|[sasha] unsetta) <var_name>: Sasha deletes <var_name>.')

        -- urbandictionary.lua --
        set_text(LANG .. 'urbandictionary:0', 1)
        set_text(LANG .. 'urbandictionary:1', '(#urbandictionary|#urban|#ud|[sasha] urban|[sasha] ud) <text>: Sasha searches <text> in the Urban Dictionary.')

        -- warn.lua --
        set_text(LANG .. 'warn:0', 7)
        set_text(LANG .. 'warn:1', 'MOD')
        set_text(LANG .. 'warn:2', '#setwarn <value>: Sasha sets max warns to <value>.')
        set_text(LANG .. 'warn:3', '#getwarn: Sasha sends max warns value.')
        set_text(LANG .. 'warn:4', '(#getuserwarns|[sasha] ottieni avvertimenti) <id>|<username>|<reply>: Sasha sends user\'s warns.')
        set_text(LANG .. 'warn:5', '(#warn|[sasha] avverti) <id>|<username>|<reply>: Sasha warns specified user.')
        set_text(LANG .. 'warn:6', '#unwarn <id>|<username>|<reply>: Sasha removes one warn from specified user.')
        set_text(LANG .. 'warn:7', '(#unwarnall|[sasha] azzera avvertimenti) <id>|<username>|<reply>: Sasha removes all warns from specified user.')

        -- webshot.lua --
        set_text(LANG .. 'webshot:0', 14)
        set_text(LANG .. 'webshot:1', 'MOD')
        set_text(LANG .. 'webshot:2', '(#webshot|[sasha] webshotta) <url> [<size>]: Sasha does a screenshot of <url> and sends it, if <size> is specified it sends of that dimension.')
        set_text(LANG .. 'webshot:3', 'Size can be:')
        set_text(LANG .. 'webshot:4', 'T: (120 x 90px)')
        set_text(LANG .. 'webshot:5', 'S: (200 x 150px)')
        set_text(LANG .. 'webshot:6', 'E: (320 x 240px)')
        set_text(LANG .. 'webshot:7', 'N: (400 x 300px)')
        set_text(LANG .. 'webshot:8', 'M: (640 x 480px)')
        set_text(LANG .. 'webshot:9', 'L: (800 x 600px)')
        set_text(LANG .. 'webshot:10', 'X: (1024 x 768px)')
        set_text(LANG .. 'webshot:11', 'Nmob: (480 x 800px)')
        set_text(LANG .. 'webshot:12', 'ADMIN')
        set_text(LANG .. 'webshot:13', 'F: Full page (can be a very long process)')
        set_text(LANG .. 'webshot:14', 'Fmob: Full page (can be a long process)')

        -- welcome.lua --
        set_text(LANG .. 'welcome:0', 5)
        set_text(LANG .. 'welcome:1', '#getwelcome: Sasha sends welcome.')
        set_text(LANG .. 'welcome:2', 'OWNER')
        set_text(LANG .. 'welcome:3', '#setwelcome <text>: Sasha sets <text> as welcome.')
        set_text(LANG .. 'welcome:4', '#setmemberswelcome <value>: Sasha after <value> members will send welcome.')
        set_text(LANG .. 'welcome:5', '#getmemberswelcome: Sasha sends value of users that are needed to get welcome.')

        -- whitelist.lua --
        set_text(LANG .. 'whitelist:0', 3)
        set_text(LANG .. 'whitelist:1', 'ADMIN')
        set_text(LANG .. 'whitelist:2', '#whitelist <id>|<username>|<reply>: Sasha adds|removes specified user to|from whitelist.')
        set_text(LANG .. 'whitelist:3', '#clean whitelist: Sasha cleans whitelist.')

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
