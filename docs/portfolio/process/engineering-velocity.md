---
title: "Engineering velocity: documentation at organizational scale"
description: Scaling a documentation standard across CoreWeave's 11+ engineering departments with a 2-person team
---

# Engineering velocity: documentation at organizational scale

This case study documents an internal project at CoreWeave where some deliverables cannot be publicly shared. The case study presents the challenge, approach, and impact of the initiative. Artifacts included are either anonymized examples or sanitized mockups that preserve confidentiality while demonstrating the scope and structure of the work.

---

!!! abstract
    **Role:** Project lead  
    **Company:** CoreWeave  
    **Timeline:** Q1-Q3 2026

## Challenge

CoreWeave's Engineering organization spans 11+ departments and is actively hiring and reorganizing, making accurate team- and department-level onboarding imperative. Documentation quality varied wildly from department to department, ranging from years of unstructured content to limited and out-of-date engagement. A new engineer had no reliable way to orient themselves to their department's role within Engineering, and the org lacked a shared standard for what department-level documentation looked like at scale.

## Approach

I built a repeatable engagement model and sprint-based rollout rather than tackling each department ad hoc:

- **Audited every department:** Assessed all 11+ department spaces to identify which needed a shell built from scratch versus which needed existing content restructured and flagged for updates
- **Designed a standard:** Built the target structure around two goals: "10-second" reader orientation, and AI enterprise search indexability
- **Bounded scope deliberately:** Landing pages, navigation, and targeted rewrites were kept in scope; net-new technical documentation and deep content gaps were flagged as follow-up work for subsequent phases to prevent project bloat
- **Built tooling to make it achievable:** Created [Claude Code skills](./ai-skills.md) that audit a space against standards developed during the initial phase, and surface abandoned or unmapped content across connected MCP sources
- **Built a repeatable engagement model:** Designed a five-stage process, from kickoff to sign-off, that cut the time per engagement and allowed for automating any identified repetition

## Key deliverables

- Comprehensive audit results for all 11+ engineering departments
- A documentation standard built for fast orientation and search indexing
- Claude Code skills for space auditing and orphaned-content discovery
- A repeatable 5-stage engagement model, from kickoff to sign-off
- Updated onboarding and organization for seven departments and counting

## Impact

This project demonstrated how documentation strategy can be sequenced and tooled to operate at organizational scale despite constrained headcount.

- **Made spaces easier to navigate:** Departments report clearer content, ownership, and leadership at a glance
- **Built a durable foundation:** The standard is designed to withstand minimal or irregular maintenance, so faster-moving content can be layered closer to where teams work
- **Improved organizational discoverability:** New hires can see where a team sits in a department and better understand what it does
- **Made unmanageable scale tractable:** Some spaces held 200+ unorganized pages; new tooling moves through high volumes directly instead of requiring time-consuming SME interviews

## Artifacts

The following are anonymized samples of work completed for this project:

<div class="preview-row">
    <a class="preview-card" href="/assets/pdfs/engagement-flow.pdf" aria-label="Engagement flow">
        <img class="preview-img" src="/assets/images/engagement-flow.png" alt="Engagement flow" />
    </a>
    <a class="preview-card" href="/assets/pdfs/kickoff-template.pdf" aria-label="Kickoff template">
        <img class="preview-img" src="/assets/images/kickoff-template.png" alt="Kickoff template" />
    </a>
    <a class="preview-card" href="/assets/pdfs/readiness-scorecard.pdf" aria-label="Space readiness scorecard">
        <img class="preview-img" src="/assets/images/readiness-scorecard.png" alt="Space readiness scorecard" />
    </a>
</div>
