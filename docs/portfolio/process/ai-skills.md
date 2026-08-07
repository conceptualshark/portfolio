---
title: AI skill library
description: Building a Claude Code skill library and Rovo conversational agent to scale a documentation review standard across CoreWeave's engineering organization
---

# AI skill library and conversational agent

This case study documents an internal project at CoreWeave where some deliverables cannot be publicly shared. The case study presents the challenge, approach, and impact of the initiative. Artifacts included are either anonymized examples or sanitized mockups that preserve confidentiality while demonstrating the scope and structure of the work.

---

!!! abstract
    **Role:** Designer and author  
    **Company:** CoreWeave  
    **Timeline:** Q2 2026

## Challenge

Organizing and architecting internal Engineering documentation is a two-person initiative. Every recurring task, from auditing existing work and gaps to drafting new guides, competes for the same limited hours; manual processes alone cannot scale at the same pace as the Engineering organization. Adopting and automating industry standards for documentation quality could reduce workloads, but additional tooling had to carry real judgment, not just automate the mechanical parts.

The answer had to not only reduce repetitive team processes, but allow engineers to adopt a self-serve review model that could keep reviews and feedback close to their existing workflows.

## Approach

None of this could be assembled from a blank slate, so I started with the standard itself and built outward:

- **Documented the standard:** Authored a living reference for AI tools to reason from, covering documentation types, style conventions, and discoverability rules
- **Built a skill library:** Organized 11 Claude Code skills into four categories by use case, each enforcing the same standard
- **Hardened against real limitations:** Every skill flags suspicious API behavior for confirmation instead of reporting a false finding
- **Adapted to different audiences:** Skills adjust language and structure depending on whether the page is designed as technical or conversational
- **Extended access beyond engineering:** Built a Rovo conversational agent that applies the same review model through chat, no engineering background required

## Key deliverables

- Internal Documentation Playbook, a living reference for internal AI tools to reason from, not only the ones developed in this project
- 11 Claude Code skills across authoring, workspace health auditing, internal project pipelines, and team operations
- Rovo conversational agent extending the same review standard company-wide
- Defensive handling for real limitations and scenarios, built into every relevant skill

## Impact

This project shifted documentation quality from something one person maintains by memory to something the tooling enforces on its own.

- **Made team projects move faster:** Pipeline skills and content-gap sweeps are a direct reason our small team scales across organization-level work
- **Became the team's working foundation:** Most current work now runs on these skills instead of starting from scratch each time
- **Shortened the path to answers:** Requests and new issues get triaged and flagged for self-service instead of routing through one person

## Artifacts

The following are anonymized samples of work completed for this project:

<div class="preview-row">
    <a class="preview-card" href="/assets/pdfs/skill-draft-internal-doc.pdf" aria-label="Draft internal doc skill">
        <img class="preview-img" src="/assets/images/skill-draft-internal-doc.png" alt="Draft internal doc skill" />
    </a>
    <a class="preview-card" href="/assets/pdfs/skill-orphan-sweep.pdf" aria-label="Orphan sweep skill">
        <img class="preview-img" src="/assets/images/skill-orphan-sweep.png" alt="Orphan sweep skill" />
    </a>
    <a class="preview-card" href="/assets/images/rovo-chat.webp" aria-label="Rovo agent page review">
        <img class="preview-img" src="/assets/images/rovo-chat-thumb.png" alt="Rovo agent page review" />
    </a>
    <a class="preview-card" href="/assets/images/rovo.webp" aria-label="Rovo agent start page">
        <img class="preview-img" src="/assets/images/rovo-thumb.png" alt="Rovo agent start page" />
    </a>
</div>
