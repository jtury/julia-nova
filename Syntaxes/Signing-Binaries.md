# Signing Binaries

Good resource from Stack Overflow here: https://stackoverflow.com/questions/61168329/how-can-i-sign-a-dylib-using-just-a-normal-apple-id-account-no-developer-accou.

Signing binaries on MacOS is pretty straightforward. First, figure out what identities you have available to sign with:
```
security find-identity -v -p codesigning
```
Then, to sign a binary, run
```
codesign --force --timestamp --sign [Certificate Name] [path/to/binary]
```

That's how I signed the dylib.
