# Pull request review criterea
These criterea shall be met during an open pull request (PR) to ensure review is done effecitvely, all feedback addressed and captured.  
Moreover, to reduce the amount of rework done on an open PR. Thereby minimizing the load on reviewers and CI.

## PR owner
* Add mandatory reviewers:
    * RFE SW Architects: Artur, Lars, Sri (At least 1 shall approve)
    * Relevant sub-architects (JIRA ticket component + components touched in the PR):
        * rfeSwAnalog: Sumit
        * rfeSwDigital: Shrey
        * rfeSwFuSA: Rajiv
        * rfeSwTesting: Dongyu
* All review comments shall be replied with the action that is taken. If off-line alignment took place, summary shall be added in reply.
* Mark review task only as resolved, when reviewer's suggestion has been accepted, implemented and pushed.
    * If a comment/task needs discussion or you disagree, you need to follow up with the reviewer and agree on resolution. 
* Any communication regarding PR/review must be captured (summarized) as comment in PR.
* PR shall be declined and reopened later, when
    * Scope of work changed or new insight arrived and PR needs to be reworked
    * It is taken out of sprint scope

## Reviewer
* PR shall meet [PR entry criterea](https://bitbucket.sw.nxp.com/projects/STRX/repos/rfe/browse/docs/Pull_Requests/Pull%20Request%20Entry.md).
    * Decline PR, when it does not comply to hard PR entry criterea or requires major rework.
    * PRs can be [reopened](https://bitbucket.sw.nxp.com/projects/STRX/repos/rfe/pull-requests?state=DECLINED), when PR is complying to the entry criterea.
* Any communication regarding PR/review must be captured (summarized) as comment in PR.
* PR shall be declined and reopened later, when
    * Scope of work changed and PR needs to be reworked.
    * New insights surfaced and PR needs to be reworked.
    * It is taken out of sprint scope.