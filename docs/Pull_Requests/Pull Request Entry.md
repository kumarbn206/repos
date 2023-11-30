# Pull request entry criterea
These criterea shall be met before opening a pull request (PR) to reduce the amount of rework done on an open PR.  
Thereby minimizing the load on reviewers, CI and have more clarity on what tickets/branches are actually ready for review.  
If a PR does not meet entry criteria it can be declined. PRs can be [reopened](https://bitbucket.sw.nxp.com/projects/STRX/repos/rfe/pull-requests?state=DECLINED), when PR is complying to the entry criterea.

## JIRA ticket
* PR implements complete ticket, meeting the definition of done.
    * 1 ticket per PR, 1 PR per ticket.
    * Tickets can be broken down in in sub-tasks, where each sub-task can have there own PR to branch of parent ticket, which afterwards can have a PR to develop.
* Any change of architecture/RFE Abstract API/externally visible behavior not captured in ticket, shall be agreed with relevant architects and added to the ticket.
* Any relevant communication regarding ticket, should be attached or summarized as comment on ticket.
* Ticket is in the sprint backlog.
* Ticket status shall be set to review state.

## Integration & Testing
* Latest develop has been merged into the branch.
* Added\modified functionality has been tested in unit test.
* PR shall not break any existing functionality in develop (even if debug or not part of CI).
* RFE firmware code added/modified in branch is minimizing code and data size (more important than speed).
* CI has passed on the branch (CI can be triggered on branch in [Jenkins](http://lsv05432.swis.nl-cdc01.nxp.com:8080/job/SmartTRX/job/rfe/), [How-to](https://bitbucket.sw.nxp.com/projects/STRX/repos/rfe/browse/docs/Pull_Requests/Trigger%20CI.md))
* If applicable, manual tests have been executed and results are added to PR.
    * Ceiling test, if HW settings of product FW are changed in branch.
    * Di/dt test, if branch touches GLDO, is powering on/off TX components or adding/removing profile loads.
    * Ticket sepcific testing, if ticket is to solve a particular issue or implement a certain feature that can only be proven by a manual test.
* No test has been disabled/ignored/margin increased unless agreed with relevant architects/integrator.
    * When it is agreed to disable/ignore at test, it shall be be ignored via TEST_IGNORE(), the rationale and the id of the follow-up ticket shall be commented in the test code and ticket. 

## Documentation
* Relevant documentation has been updated, e.g. doxygen, manuals & designs.
* Doxygen code documentation shall follow [doxygen template](https://bitbucket.sw.nxp.com/projects/STRX/repos/rfe/browse/docs/Coding_Standard/templates/rfeExampleApi.h).

## Code Quality
* Adhere to [coding standard](https://bitbucket.sw.nxp.com/projects/STRX/repos/rfe/browse/docs/Coding_Standard/coding_standard.pdf).
* No new violations for warnings/static analysis/MISRA/coverity (best effort for now until tools/CI in place).
* Code shall be self-explanatory where possible.
    * Comments shall be added, where code is not self-explanatory.
