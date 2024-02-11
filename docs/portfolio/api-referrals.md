# API Documentation: Referrals

## Summary
The following is a simplified version of design document for a set of endpoints. The related microservice handled the storage and retrieval of referred or rejected customer applications, known as Referrals. 
    
This document was created for internal use, education, and planning, and used for the ultimate creation of the REST service. It has been updated here to include interactive [Swagger documentation](#swagger-documentation), built using OpenAPI 3.0.

---

## Referral API
All endpoints designed to create and return individual or multiple referrals.

<div id="api" markdown>
### Create a new Referral
| - | - |
|---|---|
| Method: | `POST` |
| URL: | `/referrals` |
| Headers: | `content-type application/json` |

Add a new Referral to the database. Response will include a generated unique Referral ID.

``` json title="Reponse"
{
    "product": "PPD",
    "productVersion": "1.0.1",
    "submissionID": "454-jkj-400",
    "applicationID": "545-kjk-500",
    "submissionType": "New_Business|Renewal",
    "email": "customer@example.com",
    "policyNumber": "47-QAA-1232-02",
    "dateUpdated": "2021-05-13T07:30:49Z",
    "dateReferred": "2021-03-12T16:24:52Z",
    "dateCreated": "2021-03-12T16:24:52Z",
    "updatedBy": "admin@example.com",
    "rules": [
        {
            "ruleID": "cosmeticRatio",
            "ruleType": "HIGH_RISK_PROCEDURES",
            "ruleInstanceType": "triggered|underwritten",
            "updatedBy": "uw"
        }
    ]
}
```

!!! Note
    `submissionType`, `applicationID`, and `rules` may differ by product line.

``` json title="Reponse"
{
    "referralID": 1001
}
```

### Retrieve a Referral by ID
| - | - |
|---|---|
| Method: | `GET` |
| URL:	| `/referrals/{id}` |

Returns a single Referral matching the provided ID.

``` json title="Reponse"
{
    "referralID": 24,
    "product": "PPD",
    "submissionID": "454-jkj-400",
    "applicationID": "545-kjk-500",
    "submissionType": "New_Business|Renewal",
    "email": "custum@example.com",
    "policyNumber": "47-QAA-1232-02",
    "status": "Rejected",
    "dateReferred": "2021-03-12T16:24:52Z",
    "dateCreated": "2021-03-12T16:24:52Z",
    "dateUpdated": "2021-03-12T16:24:52Z",
    "updatedBy": "admin@example.com",
    "rules": [
        {
            "ruleInstanceID": 1001,
            "ruleID": "cosmeticRatio",
            "ruleType": "HIGH_RISK_PROCEDURES",
            "ruleInstanceType": "triggered|underwritten",
            "dateUpdated": "2021-03-12T16:24:52Z",
            "updatedBy": "uw"
        }
    ]
}
```

### Retrieve a list of Referrals
|-|-|
|--|--|
| Method: | `GET` |
| URL: | `/referrals?lastUpdateTime={lastUpdateTime}` |

#### Query parameters
`lastUpdateTime` **string**
: A valid Golang datetime format, e.g. `YYYY-DD-MM HH:MM:SS`.

!!! Note
    A `GET` request to the `/referrals` endpoint will retrieve all referrals.

Returns a list of Referral objects created or updated since the provided `lastUpdateTime`, including a count of all objects returned.

``` json title="Reponse"
{
   "totalCount": 1,
   "referrals": [
       {
           "referralID": 24,
           "product": "PPD",
           "submissionID": "454-jkj-400",
           "applicationID": "545-kjk-500",
           "submissionType": "New_Business|Renewal",
           "email": "customer@example.com",
           "policyNumber": "47-QAA-1232-02",
           "status": "Rejected",
           "dateReferred": "2021-03-12T16:24:52Z",
           "dateCreated": "2021-03-12T16:24:52Z",
           "dateUpdated": "2021-03-12T16:24:52Z",
           "updatedBy": "admin@example.com",
           "rules": [
               {
                   "ruleInstanceID": 1001,
                   "ruleID": "cosmeticRatio",
                   "ruleType": "HIGH_RISK_PROCEDURES",
                   "ruleInstanceType": "triggered|underwritten",
                   "dateUpdated": "2021-03-12T16:24:52Z",
                   "updatedBy": "uw"
               }
           ]
       }
   ]
}
```
</div>

### Response codes
| Code | Definition |
|---|---|
| `201` | Success. The referral was created or retrieved successfully. |
| `400` | Malformed request. Invalid or missing mandatory data. |
| `500` | The server encountered an error while handling this request. |

## Swagger Documentation
!!swagger referrals.json!!