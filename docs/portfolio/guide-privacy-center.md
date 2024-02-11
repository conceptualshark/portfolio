# User Guide: Privacy Center

## Summary

The Fides suite of open-source privacy tools also included a configurable "Privacy Center:" a deployable webpage for quickly setting up legislation-compliant privacy actions and consent management. This guide walks through basic configuration options and settings.

---

## Overview
The Fides Privacy Center is a configurable webpage where users can request to access, update, or delete their data or update their consent preferences. The Privacy Center can be modified by creating and editing a configuration file, and is then deployable alongside your Fides implementation.

## Create the configuration file

The Fides Privacy Center's text and actions are managed by a `config.json` file, which is located in your project's `/clients/app/config` directory. 

1. Copy the `config.json` template located in [this repository](../assets/config.json).
2. Create a `config.json` in your project's `/clients/app/config` directory, and paste the contents of the template.

Running the Privacy Center from this template will result in the following default webpage:

![Default Privacy Center](../assets/images/privacy-center.gif)

### Edit the default options

The title, description, and logo for your Privacy Center can be customized with the following fields:

| Field | Description |
|---|---|
| `title` | The user-facing title of the Privacy Center. |
| `description` | A user-facing description for the Privacy Center. |
| `logo` | The URL to a public logo. Will override the default icon. |

## Configure privacy request options

The list of available privacy request functions is controlled by the `Actions` section of the `config.json`. Adding a new action creates a new tile in your Privacy Center, which contains any attributes the action defines.

Actions can be customized with the following fields:

| Field | Description |
|---|---|
| `title` | The user-facing title of the tile. This should describe the function being performed. |
| `description` | A user-facing description for the action tile. |
| `icon_path` | The URL to a public icon. Will override the default icon. |
| `policy_key` | The key of the policy to run when the action is triggered. |
| `identity_inputs` | A list of personally identifiable information gathered to perform an action, and whether or not each item is required. Fides will use these inputs to find associated records. |

### Example access request
The following action creates a tile in your Privacy Center with the title **Access your data**. This action requires the user to enter their email address to return the generated report, and uses the `default_access_policy` on associated data when submitted.

```json
"actions": [
    {
    "title": "Access your data",
    "description": "We will email you a report of the data related to your account.",
    "icon_path": "/download.svg",
    "policy_key": "default_access_policy",
    "identity_inputs": {
        "name": "optional",
        "email": "required",
        "phone": "optional"
      }
    }
]
```

## Configure consent options

The Fides Privacy Center allows users to customize their consent preferences, and uses cookies to recognize visitors and remember their choices. The consent preference page is accessed by a consent tile, and each can be further customized in the `consent` section of your `config.json` to match your Privacy Center experience.

### Consent tile

The **Manage your consent** tile displays in your list of privacy request actions.

The consent tile can be customized with the following fields:

| Field | Description |
|---|---|
| `includeConsent` | `true` or `false`. Whether or not to include a consent tile in the privacy center. |
| `title` | The user-facing title of the tile. This should describe the function being performed. |
| `description` | A user-facing description for the action tile. |
| `icon_path` | The URL to a public icon. Will override the default icon. |
| `identity_inputs` | A list of personally identifiable information gathered to perform an action, and whether or not each item is required. Fides will use these inputs to find associated records. |

### Consent option page

The consent option page displays a list of your configured consent notices, and can be customized with the following fields:

| Field | Description |
|---|---|
| `title` | The user-facing title of the consent options page. | 
| `description` | The user-facing description for the consent options page. | 
| `description_subtext` | Any additional paragraphs of text to display on the consent options page. | 
| `policy_key` | The key of the policy to run when the action is triggered. |
| `consentOptions` | A list of consent notices that should appear on the page. | 

### Individual consent options

Individual consent options represent opt-in or opt-out user experiences, such as **Data Sharing and Sales** or **Newsletters and Emails**. 

Consent opions can be customized with the following fields:

| Field | Description |
|---|---|
| `name` | The user-facing name of the consent option, i.e. `Data Sharing`. | 
| `description` | The user-facing description of the consent option. |
| `url` | The URL where a user can view a descriptive consent notice. |
| `default` | If this consent preference is enabled (`true`) or disabled (`false`) by default. |
| `highlight` | If this consent preference is highlighted (`true`) or not (`false`). |
| `executable` | Whether the user's consent choice should be propagated to third-party integrations connected to your instance of Fides. |

### Example opt-out consent

The following `consent` configuration creates a tile in the Privacy Center, a consent `page` titled **Manage your consent**, and a **Data Sales and Sharing** `consentOption` that is enabled (`true`) but default.

```json 
    "includeConsent": true,
    "consent": {
        "button": {
            "title": "Manage your consent",
            "description": "Manage your consent preferences",
            "description_subtext": [
                "In order to opt-out of certain consent preferences, we may need to identify your account via your email address. This is optional."
            ],
            "icon_path": "/consent.svg",
            "identity_inputs": {
                "email": "optional"
            }
        },
        "page": {
            "title": "Manage your consent",
            "description": "Manage your consent preferences, including the option to select 'Do Not Sell or Share My Personal Information'.",
            "description_subtext": [
                "When you use our services, you're trusting us with your information. We understand this is a big responsibility and work hard to protect your information and put you in control."
            ],
            "policy_key": "default_consent_policy",
            "consentOptions": [
                {
                    "fidesDataUseKey": "marketing.advertising",
                    "name": "Data Sales and Sharing",
                    "description": "We may use some of your personal information for behavioral advertising purposes, which may be interpreted as 'Data Sales' or 'Data Sharing' under regulations such as CCPA, CPRA, VCDPA, etc.",
                    "url": "https://example.com/privacy#data-sales",
                    "default": {
                        "value": true,
                        "globalPrivacyControl": false
                    },
                    "highlight": false,
                    "cookieKeys": [
                        "data_sales_and_sharing"
                    ],
                    "executable": false
                }
            ]
        }
    }
```

## Configure appearance
 
The Privacy Center supports additional customization in the form of CSS overrides. To configure a custom appearance for the website, upload a CSS stylesheet named `config.css` to the `/privacy-center/config` directory of your project. 

By default, Fides uses the [Chakra UI framework](https://chakra-ui.com/) to assist in styling.

### CSS override example
In order to modify the heading text, Chakra has a default `chakra-heading` class style that is assigned to each header (h1, h2, h3, etc). The following offers two methods of modifying headers:

```css
/* Apply changes to all headings of the site */
.chakra-heading {
    color: #0000FF; /* Set text color to blue */
    font-size: 1.5em; /* Increase font size by 50% */
    font-weight: 300; /* Lighten font weight */
}
/* Apply changes only to heading 2 <h2> */
h2.chakra-heading {
    color: #0000FF; /* Set text color to blue */
    font-size: 1.5em; /* Increase font size by 50% */
    font-weight: 300; /* Lighten font weight */
}
```

A list of configurable properties is available in the [Chakra documentation](https://chakra-ui.com/docs/styled-system/style-props).