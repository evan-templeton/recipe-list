# recipe-list
|**All Recipes**|**Malformed Data**|**Empty Data**|
|----|----|----|
|![Simulator Screenshot - iPhone 16 Pro - 2025-03-14 at 13 31 03](https://github.com/user-attachments/assets/88d910b7-c310-4e7f-af68-fbd3797a9495)|![Simulator Screenshot - iPhone 16 Pro - 2025-03-14 at 13 31 03](https://github.com/user-attachments/assets/01332049-6213-4a24-91d5-f4281c1f3b71)|![Simulator Screenshot - iPhone 16 Pro - 2025-03-14 at 14 43 58](https://github.com/user-attachments/assets/0b7ccf04-b0c8-4857-97de-b792f588e3cc)|

### Focus Areas
_What specific areas of the project did you prioritize? Why did you choose to focus on these areas?_
- Requirements ask for the entire list of results to be thrown out if a single recipe is malformed. I'm happy to do this, but I don't think it's a good UX. As an alternative, I built `FailableDecodable` to skip malformed results.

- RecipeServiceProtocol is used as a generic constraint (rather than existential) for static dispatch
  - `RecipeListViewModel` takes in a generic `Service` for unit testing

- ViewModel publishes a single state enum to ensure data consistency
  - Note this is not View state (View and logic concerns are still separated)

### Time Spent
_Approximately how long did you spend working on this project? How did you allocate your time?_
- 2hrs/day for four days
  - Day 1: high level view, VM, and service
  - Day 2: refinement and tests
  - Day 3: cleanup and readme
  - Day 4: `RecipeServiceTests`

### Trade-offs and Decisions
_Did you make any significant trade-offs in your approach?_
- The project overview says "the app should consist of just one screen displaying the list of recipes", which I read as "we don't want you to load the `source_url` and show the actual recipe when a cell is tapped." I'm not sure if this is right, so if y'all do in fact want this functionality I'm happy to add it.

### Weakest Part of the Project
_What do you think is the weakest part of your project?_

The following seem like overkill for a project of this size, but I'd consider them to be weak choices:
- `RecipeListView` doesn't support pagination
- Images are cached per session, not persistent
- Views don't support UI Testing
- App doesn't support localization
