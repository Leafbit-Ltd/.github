# Apple Mail signature installer

This folder contains a Mac installer script for Lydia Norton's Leafbit email signature.

Apple Mail does not support double-click importing an HTML signature file. The supported Apple UI is Mail > Settings > Signatures, where users paste text, links, and images. For a real HTML signature, the practical Mac workaround is to create or register a `.mailsignature` file in Mail's local signature folder.

## Recommended install

1. Quit Apple Mail completely.
2. Download [`install-lydia-norton.command`](install-lydia-norton.command).
3. In Finder, right-click the downloaded file and choose **Open**.
4. If macOS warns that the file is from the internet, choose **Open** again.
5. Reopen Apple Mail.
6. Go to **Mail > Settings > Signatures**.
7. Select the `Leafbit - Lydia Norton` signature for Lydia's email account.
8. Compose a test email to confirm the logo, email link, and website link work.

If macOS says the file is not executable, open Terminal and run:

```sh
chmod +x ~/Downloads/install-lydia-norton.command
~/Downloads/install-lydia-norton.command
```

## What the installer does

- Finds Apple Mail's active `Signatures` folder.
- Backs up `AllSignatures.plist` before editing it.
- Adds a new `Leafbit - Lydia Norton` signature entry.
- Writes the matching `.mailsignature` HTML file.
- Leaves existing signatures and account settings in place.

The installer does not know which Apple Mail account Lydia wants to use, so it does not force a default account assignment. Lydia should select the new signature in Mail's settings after installation.

## If the installer cannot find Mail signatures

Open Apple Mail once, create any temporary signature in **Mail > Settings > Signatures**, quit Apple Mail, then run the installer again. This forces Apple Mail to create the local signature folder and `AllSignatures.plist`.

## If the logo does not appear

The signature uses the HTTPS logo hosted on `leafbit.uk`, which is more reliable than a GitHub raw image URL and avoids sending the logo as an attachment. If Apple Mail still hides the logo, check **Mail > Settings > Privacy** and make sure **Block All Remote Content** is not enabled.
