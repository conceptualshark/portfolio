# API Documentation: Privacy Requests

## Summary

Prior to moving to a deployable webserver with a built-in UI, the [Fides](https://github.com/ethyca/fides) privacy automation platform relied on detailed API usage guides to walk users through available features and tools. This guide served to introduce technical users to the legal aspect of privacy requests and requirements, and document the methods developers could use to integrate Fides' open-source software into their workflows.

---

## What is a privacy request?
Privacy requests are Fides' representation of Data Subject Requests (DSRs) or Data Subject Access Requests (DSARs). Laws like the European Union’s **GDPR**, California’s **CCPA**, and Connecticut’s **CTDPA** grant individuals the legal right to access, modify, or delete the personal data that a company holds on them. 

With Fides, privacy requests submitted by your users are fulfilled immediately and automatically, returning and impacting data described by customizable execution policies.

## Overview

The `/api/v1/privacy-request` API is a collection of routes that `create`, `read`, and `update` privacy requests and related actions. Use these endpoints to create a custom privacy request experience.

## Create a privacy request
```json title="<code>POST /api/v1/privacy-request</code>"
[
  {
    "external_id": "a-user-defined-id",
    "requested_at": "2021-10-31T16:00:00.000Z",
    "policy_key": "a-demo-policy",
    "identity": {
      "email": "identity@example.com",
      "phone_number": "+1 (123) 456 7891"
    }
  }
]
```

The above request will apply the `a-demo-policy` execution policy to all target data that can be generated from the email address `identity@example.com`, and the phone number `+1 (123) 456 7891`. 

!!! Info
     Execution policies specify what actions to take when a user submits a request to retrieve or delete their data. These policies describe _how_ to access, mask, or erase any information that matches the submission.

| Attribute | Description |
|---|---|
| `external_id` | *Optional.* An identifier to track the privacy request for reporting. |
| `requested_at` | *Optional.* An ISO8601 timestamp specifying the moment that the request was submitted. Defaults to the `created_at` time if not specified. |
| `policy_key` | Identifies the execution policy applied to this request. |
| `identities` | An array of objects. These objects identify any users whose data will be affected by the execution policy. Each object identifies a single user.  |


### Subject identity verification 
Fides supports user verification prior to request processing. With identify verification enabled, a user will be emailed a six-digit code when they submit a privacy request. They must supply that verification code to Fides to continue privacy request execution.  

!!! Note
    To use identity verification, the `subject_identity_verification_required` variable in your `fides.toml` configuration file must be set to `TRUE`.
    
The privacy request status is set to `identity_unverified` until the verification request receives a response.

```json title="<code>POST api/v1/privacy-request/{privacy_request_id}/verify</code>"
{"code": "verification code"}
```

## Approve and deny privacy requests

!!! Note
    Fides processes privacy requests immediately by default. To review privacy requests before they are executed, the `require_manual_request_approval` variable in your `fides.toml` configuration file must be set to `TRUE`.

To process pending privacy requests, a list of privacy request IDs can be sent to either the `approve` or `deny` endpoints. Both endpoints support processing requests in bulk.

```json title="<code>PATCH api/v1/privacy-request/administrate/approve</code>"
{
  "request_ids":[
    "pri_2d181f15-486d-4bcf-a871-f50ed9f95673",
    "pri_2d181f15-486d-4bcf-a871-f50ed9f95673"
  ]
}
```

Optionally, a denial reason can be provided when denying a privacy request:
```json title="<code>PATCH api/v1/privacy-request/administrate/deny</code>"
{
  "request_ids":[
    "pri_2d181f15-486d-4bcf-a871-f50ed9f95673",
    "pri_2d181f15-486d-4bcf-a871-f50ed9f95673"
  ],
  "reason": "Requests denied as duplicates"
}
```

### Monitor in-progress requests
Privacy requests can be monitored at any time throughout their execution by calling either of the following endpoints:

```title="GET request"
api/v1/privacy-request?request_id={privacy_request_id}
```

```title="GET request"
api/v1/privacy-request?external_id={external_id}
```

### Restart failed requests
To restart a failed privacy request, call the following endpoint with an empty request body:

```
POST /api/v1/privacy-request/<privacy_request_id>/retry
```

## Encrypt requests
Access request results can be encrypted by supplying an `encryption_key` string in the request body. Fides uses the supplied `encryption_key` to encrypt the contents of your JSON and CSV results using an AES-256 algorithm in GCM mode.

Your `encryption_key` must be 16 bytes long. The data returned will have the nonce concatenated 
to the encrypted data.

```json title="<code>POST /privacy-request</code>"
[
    {
        "requested_at": "2021-08-30T16:09:37.359Z",
        "identity": {"email": "customer-1@example.com"},
        "policy_key": "my_access_policy",
        "encryption_key": "test--encryption"
    }
]

```

### Decrypt results

Fides encrypts request data using your provided key, and an internally-generated nonce with an AES 256 algorithm in GCM mode. The return value is a 12-byte nonce plus the encrypted data that is b64 encoded together. 

```
+------------------+-------------------+
| nonce (12 bytes) | message (N bytes) |
+------------------+-------------------+
```
To decrypt the results, you must convert the message to bytes, decode the b64 string, and separate the 12-bite nonce from the encrypted message. You can then use any GCM decryption library to decrypt the message with your private encryption string.

In the example below, a message was encrypted using the key `test--encryption`, resulting in an encrypted string. After converting and decoding the b64 string, the nonce can be separated from the resulting bites, and the message decrypted using the AESGCM lirary.

```python title="Sample decryption"
import json
import base64
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

encrypted: str = "GPUiK9tq5k/HfBnSN+J+OvLXZ+GCisapdI2KGP7A1WK+dz1XHef+hWb/SjszdqdNVGvziyY6GF5KIrvrXgxjZuaAvgU=" 
encryption_key: str = "test--encryption".encode("utf-8")  # Your private encryption string

encrypted_combined: bytes = base64.b64decode(encrypted)
nonce: bytes = encrypted_combined[0:12]
encrypted_message: bytes = encrypted_combined[12:]
gcm = AESGCM(encryption_key)

decrypted_bytes: bytes = gcm.decrypt(nonce, encrypted_message, nonce)
decrypted_str: str = decrypted_bytes.decode("utf-8")

json.loads(decrypted_str)
```

```python title="Sample result"
>>> {"street": "test street", "state": "NY"}
```