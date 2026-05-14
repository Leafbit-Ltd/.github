#!/bin/bash
set -euo pipefail

signature_name="Leafbit - Lydia Norton"
signature_unique_id="$(uuidgen | tr '[:lower:]' '[:upper:]')"
message_id="$(uuidgen | tr '[:lower:]' '[:upper:]')"

fail() {
  printf 'Leafbit Apple Mail installer: %s\n' "$1" >&2
  exit 1
}

file_mtime() {
  stat -f '%m' "$1" 2>/dev/null || stat -c '%Y' "$1"
}

find_newest_plist() {
  search_root="$1"
  search_pattern="$2"

  [ -d "$search_root" ] || return 0

  find "$search_root" -path "$search_pattern" -type f -print 2>/dev/null |
    while IFS= read -r plist_file; do
      printf '%s\t%s\n' "$(file_mtime "$plist_file")" "$plist_file"
    done |
    sort -nr |
    head -n 1 |
    cut -f 2-
}

find_signatures_dir() {
  if [ -n "${LEAFBIT_MAIL_SIGNATURES_DIR:-}" ]; then
    printf '%s\n' "$LEAFBIT_MAIL_SIGNATURES_DIR"
    return 0
  fi

  icloud_plist="$HOME/Library/Mobile Documents/com~apple~mail/Data/MailData/Signatures/AllSignatures.plist"
  if [ -f "$icloud_plist" ]; then
    dirname "$icloud_plist"
    return 0
  fi

  newest_icloud_plist="$(find_newest_plist "$HOME/Library/Mobile Documents/com~apple~mail/Data" '*/Signatures/AllSignatures.plist')"
  if [ -n "$newest_icloud_plist" ]; then
    dirname "$newest_icloud_plist"
    return 0
  fi

  newest_local_plist="$(find_newest_plist "$HOME/Library/Mail" '*/MailData/Signatures/AllSignatures.plist')"
  if [ -n "$newest_local_plist" ]; then
    dirname "$newest_local_plist"
    return 0
  fi
}

if [ "${LEAFBIT_ALLOW_MAIL_RUNNING:-0}" != '1' ] && pgrep -x Mail >/dev/null 2>&1; then
  fail 'Apple Mail is running. Quit Mail completely, then run this installer again.'
fi

signatures_dir="$(find_signatures_dir || true)"
[ -n "$signatures_dir" ] || fail 'Could not find Apple Mail signatures. Open Apple Mail, create a temporary signature, quit Mail, then run this installer again.'

all_signatures_plist="$signatures_dir/AllSignatures.plist"
[ -f "$all_signatures_plist" ] || fail "Could not find $all_signatures_plist"
[ -w "$all_signatures_plist" ] || fail "Cannot write to $all_signatures_plist"

backup_path="$all_signatures_plist.leafbit-backup-$(date +%Y%m%d%H%M%S)"
cp "$all_signatures_plist" "$backup_path"

/usr/libexec/PlistBuddy -c 'Add :0 dict' "$all_signatures_plist"
/usr/libexec/PlistBuddy -c 'Add :0:SignatureIsRich bool true' "$all_signatures_plist"
/usr/libexec/PlistBuddy -c "Add :0:SignatureName string $signature_name" "$all_signatures_plist"
/usr/libexec/PlistBuddy -c "Add :0:SignatureUniqueId string $signature_unique_id" "$all_signatures_plist"

mailsignature_file="$signatures_dir/$signature_unique_id.mailsignature"

cat > "$mailsignature_file" <<HTML
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
 charset=utf-8
Message-Id: <$message_id>
Mime-Version: 1.0

<table role="presentation" cellpadding="0" cellspacing="0" style="border-collapse:collapse; font-family:Arial, Helvetica, sans-serif; color:#40423f; max-width:520px;">
  <tr>
    <td style="padding:0 18px 0 0; vertical-align:middle; border-right:2px solid #8ea056;">
      <a href="https://leafbit.uk" style="text-decoration:none;">
        <img src="https://raw.githubusercontent.com/Leafbit-Ltd/.github/main/images/rectangle_no_background.png" width="148" alt="Leafbit" style="display:block; width:148px; max-width:148px; height:auto; border:0;">
      </a>
    </td>
    <td style="padding:0 0 0 18px; vertical-align:middle;">
      <table role="presentation" cellpadding="0" cellspacing="0" style="border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
        <tr>
          <td style="padding:0 0 2px 0; font-size:18px; line-height:22px; font-weight:bold; color:#3c6449;">
            Lydia Norton
          </td>
        </tr>
        <tr>
          <td style="padding:0 0 10px 0; font-size:13px; line-height:18px; color:#40423f;">
            Director
          </td>
        </tr>
        <tr>
          <td style="padding:0; font-size:13px; line-height:19px; color:#40423f;">
            <a href="mailto:lydia@leafbit.uk" style="color:#3c6449; text-decoration:none;">lydia@leafbit.uk</a>
          </td>
        </tr>
        <tr>
          <td style="padding:0; font-size:13px; line-height:19px; color:#40423f;">
            <a href="https://leafbit.uk" style="color:#3c6449; text-decoration:none;">leafbit.uk</a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
HTML

printf 'Installed "%s" in Apple Mail.\n' "$signature_name"
printf 'Signature file: %s\n' "$mailsignature_file"
printf 'Backup created: %s\n' "$backup_path"
printf '\nNext steps:\n'
printf '1. Open Apple Mail.\n'
printf '2. Go to Mail > Settings > Signatures.\n'
printf '3. Select "%s" for Lydia'\''s email account.\n' "$signature_name"
printf '4. Compose a test email and confirm the logo and links work.\n'
