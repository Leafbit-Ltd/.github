# Leafbit email signatures

Importable HTML email signatures for Leafbit employees.

## Quick actions

- [Preview and copy Lydia Norton's signature](index.html)
- [Open Lydia Norton's standalone HTML signature](lydia-norton.html)
- [Install Lydia Norton's signature in Apple Mail](apple-mail/)
- [Open Gmail signature settings](https://mail.google.com/mail/u/0/#settings/general)
- [Open Outlook signature settings](https://outlook.live.com/mail/0/options/mail/layout/messageContent)

There is no reliable universal "add to mail app" link for HTML signatures. Gmail and Outlook expect the rendered signature to be copied into their own signature editor. Apple Mail can be installed more directly with a small Mac installer script, but still requires the employee to choose the new signature in Mail's settings afterwards.

## Lydia Norton

- File: [`lydia-norton.html`](lydia-norton.html)
- Role: Director
- Email: [lydia@leafbit.uk](mailto:lydia@leafbit.uk)
- Website: [leafbit.uk](https://leafbit.uk)

## Best way to preview

Open [`index.html`](index.html) in a browser from a local checkout, or publish the `signatures/` folder through GitHub Pages and open it there. GitHub's normal file viewer shows HTML source code, not the rendered email signature, so it is not a reliable preview.

The preview page includes:

- A rendered signature preview.
- A "Copy signature" button that copies rich HTML for pasting into a mail client.
- A "Download HTML" button for employees who need the standalone `.html` file.
- Short Gmail, Outlook, and Apple Mail install guidance.
- A separate Apple Mail installer for Mac users in [`apple-mail/`](apple-mail/).

## Manual importing

1. Open the HTML file in a browser.
2. Select the rendered signature, not the source code.
3. Copy it and paste it into the email client's signature editor.
4. Send a test email to confirm the logo, email link, and website link work.

The logo uses the hosted image in this repository so it can still load after the signature is copied into a mail client.
