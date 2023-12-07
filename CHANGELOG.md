[0.1.0]
* Initial version

[0.2.0]
* Fix description

[0.3.0]
* Add LDAP support

[0.4.0]
* Use latest base image 2.0.0
* Update to osTicket 1.14.2

[1.0.0]
* Add forumUrl
* Make php.ini customizable via `/app/data/php.ini`

[1.1.0]
* Allow user-managed plugins

[1.1.1]
* Update osTicket to 1.14.3
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.14.3)
* inline: RichText Fields View First (d8ff946, a97ddba)
* print: Update Icons and Add Titles (be18e46)
* issue: Update Print Options Icons/Text/Title (b4cd46a)
* refactor: Help Topic Status Refresh (2dee16b)
* Adding translation to the dashboard plot labels. (ebfd68b)
* Issue: Language Verification (a1e9342)

[1.1.2]
* Update osTicket to 1.14.4
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.14.4)
* forms: Pseudo-random name for Dynamicforms on POST (077d26f)
* Authcode: Ticket Access Link (043c3fe)
* redactor: Upgrade to version 3.4.5 (e593c5c, 9102240, e471132)
* Auth: Client Create Request (c3c01d3, 43e07c2)

[1.2.0]
* Update osTicket to 1.15
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.15)
* Change dept_id and priority_id fron tinyint to int (e54f6f3)
* csrf: Add ability to rotate token (36e614c)
* Feature: Agent/Department Visibility (5fbd762, e4346d2, 4ad7e95, 49b2f1b, 46033d1, 3a8ea4b, 6eae7e6, f306ce8, 6fdc111, 4489b2f, 7f0602a, 484023d, 3722fc5, 6425146, 9902ac2, 07b2373, ca81176, 4e86313)
* db: Latest Indexes (da2fd37, 2731074, c359d12, ea09373, 4c9968b)
* SLA Plan Search Field (0fd63b4)
* 2FA Backends (5dd0a34, 4ef752c, cff12f7, ea86103, 4b6bc73, a1b7826, 3f08e62, 9d46c84, 8f4fe18)
* Password Policy Revisited (e1aba7c, 744676b)

[1.2.1]
* Update osTicket to 1.15.1
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.15.1)
* placeholder: Quote and encode html chars (0056d14)

[1.2.2]
* Set TRUSTED_PROXIES config variable so that reverse proxy vars are respected

[1.3.0]
* Fix issue where the mail from address was not update correctly

[1.4.0]
* Update base image to v3

[1.4.1]
* Update osTicket to 1.15.2
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.15.2)
* Issue: Visibility Permissions (8da9da3)
* Depts Visibility (fe37ae2)
* Issue: Task Inline Transfer (e43d6bf)
* xss: FormAction Attribute (8d956e0)
* xss: onerror Property (25e6d12)

[1.4.2]
* Fix buggy cron task

[1.4.3]
* Update osTicket to 1.15.3.1

[1.4.4]
* Update osTicket to 1.15.4
* Improvements
  * Issue: Delete Referrals (790c0e6)
  * Show "-Empty-" value for empty due dates in ticket view (64712eb)
  * Issue: Audit Closed Ticket Events (311a600)
* Security
  * security: PwReset Username and Username Discoverability (e282910, 86165c2)
  * security: SSRF External Images (1c6f98e)
  * xss: Stored XSS/Domain Whitelist Bypass (4b4da5b)
  * security: Recipient Injection via User's Name (7c5c584)
  * xss: Advanced Search (4a8d3c8)
  * xss: Tasks (b01c6a2)

[1.4.5]
* Update base image to 3.2.0

[1.5.0]
* Update osTicket to 1.16.1
* Update PHP to 8.0
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.16)

[1.5.1]
* Update osTicket to 1.16.2
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.16.2)
* Issue: Topic->getHelpTopics() don't return localized names when $allData = true (a078a0f)
* class.email: allow empty smtp_passwd when existing (0d0d8a1)
* Fixes permission issue when registration mode ist disabled (dee6a13)
* email: use correct e-mail formatting (7692637)
* Fix HTML syntax in thread view (84913f5)

[1.5.2]
* Update osTicket to 1.16.3
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.16.3)
* installer: Help Topic Disabled Fields (81e99fe)
* Do not autocomplete new access fields of the (another) user (0263369)
* issue: mPDF Table Print (38c0979)
* Make string localizable (4cc509b, 612183c)

[2.0.0]
* Update osTicket to 1.17.0
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.17)
* **Email management has changed and is now left to the user to configure as multiple mail accounts on- or off-Cloudron may be used**
* email: Set Default Email Message Encoding to UTF-8 (4656cf4, 8954f05)
* plugins: Multi-Instance Blacklist (5607751)
* mailer: Reset FROM Address when SMTP fails (75605a3)
* Issue: File Storage Plugins Blacklist (1ba8d37)
* mail: Catch Possible Exceptions and Errors (81d5cb3)
* Update class.mail.php (d5545b4)
* Mail Fetcher Fixes (1eebcd6, 3decbe7)
* 1.17.x Bug Fixes (6c2ecad, 5d799ec, 21e3a40)
* plugins: Make Plugins Upgradeable Again! (80bcc19)
* mailer: Skip Invalid Email Recipients (046f432, 551f786, d7d37c4)
* issue: Wrong Variable Order (12a4cb0)
* mailer: Skip Missing Attachment Files (2218aac)
* fetcher: TicketDenied Exception + Throwable (58f64e6, 7920914, e027dcc, be178da)
* files: Catch possible Storage Backends Errors (e685636)
* fetcher: Fail Safely on Email Parse Error (459520e)
* forms: Add getNotice func. to DynamicFormEntry (6e54e81)
* bug: Users Password Policy (ebfc1d8)
* v1.17 Misc. Fixes (d149ea0)
* plugins: Make Plugin Base Class Play Nice (7b26f66, 5787f9a, 3163972)

[2.0.1]
* Update osTicket to 1.17.2
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.17.1)
* mail: Add plain:// encryption scheme hint (7c1b97b3, 39d76258)
* mailer: Make Headers Valid Again (c08a8a8, aaee6b0, 0098155, 2223877, 020fa0d, 60c8c88)
* POP3 Configration can not saved (b84547b, ccd8445)
* fetcher: Errors Handling & Logging (384aad1, 22edf2b, c92006e)
* upgrader: Email Account Status (aee25d6)
* issue: Plugin Config Item Exists (fdf9e41)
* mailer: Improvements & Enhancements (845e500, 23a8059, 977cf9a)
* smtp: Use proper name when saying What's Up (HELO/EHLO) (b0e5ac8)
* email: Make sure Email Account is Active 4realz! (5efd9f1, a9b5749)
* Session++ (ced0ef4, b943a95, b6b63c9, f58e1c5, 47df2b4, e2e6c0f, 9ab5b4f, da66736, f2c0184, c2be4eb, db913bd)
* setup: Use Bootstrap:ini() to initialize setup dir sessions (48e436f)
* issue: Plugin Config Item Exists (fdf9e41)
* upgrader: Email Account Status (aee25d6)
* fetcher: Errors Handling & Logging (384aad1, 22edf2b, c92006e)
* fetcher: Mail Fetch Order (f1639d4, 24338c2)
* SMTP: Dont send 'QUIT' on `__destruct()` (dbeae22)
* issue: MTA Typo (03eeb8e)
* sendmail: Strip "To" and "Subject" headers (ac3855a)
* Mail Parse Error Handling (320981d, 75c5cfe, a4e36d3, ba2d31c, 30ad9cd, 678098d, 46b7899, f85f903)
* Issue/session revisited (49d91b0, 4fc5f5c)
* Fix old reference to SessionData (cf8b8ce7)
* Email Misc. Fixes (de620fe6, c19a5f03)
* session: Memcache Max TTL (ea3e03d2)
* mailer: Use Namespaced Mailer (133585f8)

[2.0.2]
* Update osTicket to 1.17.3
* Update PHP to 8.0
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.17.3)
* session: Regenerate Session Id (d5853245)
* fetcher: Mail Fetcher / Parser Error Handling (d4d9c424, 0a4498b2)
* mysql: Support Sidecar Database Proxies (246aaa4d)
* Misc. Fixes (e6beeb9b, 24fd5075, eac9960a, 10af29a5)
* fetcher: Default Department (f410d4ec)
* issue: LDAP Multi-Instance Fatal Error (f6486044)
* issue: TicketDenied errno (6de7cf4c)
* session: User Logged Out (00d409d3)
* Uncaught Error: Call to a member function getId() on bool (af83896d)
* Mailer: Inline Images (7efbdfd2, 8815d087, 64a8abf3)

[2.0.3]
* Update osTicket to 1.17.4
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.17.4)
* issue: Thread Entry Actions z-index (215a0ce2)
* oauth2: Strict Matching Bug (e014ffd2)
* Make string translatable (1105cde7)
* issue: Inline-Images Canned Responses (4493b126)
* issue: Remove Old Login Code (e17ad463)
* issue: i18n Audit Exports (45dd7c4f)
* Bug: Custom File Upload Field Config (6371269a, 7283ac81, 902b5d35)
* issue: Duplicate User Copy/Paste Import (b304cdb)
* issue: Relocate Typeahead JS/CSS Files (62cd406)
* issue: strftime() Deprecation (3fe132c4)
* jquery: Update To 3.7.0 (ffa23da)
* issue: glob() Empty Array (c64a2611)
* issue: Email Only Attachment (9e45f3fa)
* installer: Change Email (a11aee29)
* security: Latest Vulns 06/2023 (86c2ba02, 69244175, 73b997a, ae37925, e4bfb00)

[2.1.0]
* Update osTicket to 1.18.0
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.18)
* update: Laminas-Mail (66fa10af, bb45d37a)
* Database: Change Plugin Name to varchar(255) (aac546d0)

[2.2.0]
* Update base image to 4.2.0

[2.2.1]
* Update osTicket to 1.18.1
* [Full changelog](https://github.com/osTicket/osTicket/releases/tag/v1.18.1)
* Update upgrade.php (9fd83eb)
* Update upgrade.inc.php (8c8a7fd)
* update: PHP Requirements 1.18.x (1c0c670)
* CLI: Make sure manage util can be executed via CLI (0caf586)
