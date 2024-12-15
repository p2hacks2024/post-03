# Do Later iOS

## fastlane/.env.default

| Name                                     | Description                                       |
| :--------------------------------------- | :------------------------------------------------ |
| APP_STORE_CONNECT_API_KEY_ID             | Required when you modify certificates or profiles |
| APP_STORE_CONNECT_API_KEY_ISSUER_ID      | Required when you modify certificates or profiles |
| APP_STORE_CONNECT_API_KEY_CONTENT_BASE64 | Required when you modify certificates or profiles |
| FIREBASE_APP_DISTRIBUTION_GROUPS         | e.g. `team-all`                                   |
| FIREBASE_APP_ID                          | Refer `GoogleService-Info.plist`                  |
| IOS_CERTS_GITHUB_APP_ID                  |                                                   |
| IOS_CERTS_GITHUB_APP_SECRET              |                                                   |
| MATCH_KEYCHAIN_NAME                      | Set in CI environment                             |
| MATCH_KEYCHAIN_PASSWORD                  | Set in CI environment                             |
| MATCH_PASSWORD                           |                                                   |
| SLACK_URL                                |                                                   |

## Setup

### Project

```bash
make install
```

### Fetch Developement Certificate and Profile

```bash
make match_fetch_development
```

## For Admin

### Register a new bundle identifier

```bash
make register_bundle_id id='com.kantacky.DoLater'
```

### Register a new device

```bash
make register_device name="'Kanta'\''s iPhone 16 Pro'" udid='00000000-0000000000000000'
```

&copy; 2024 Kanta Oikawa
