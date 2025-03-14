# recipe-list
### Summary:


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
- ViewModel publishes a single state enum to ensure data consistency
 - Note this is not View state (View and logic concerns are still separated)

- RecipeServiceProtocol is used as a generic constraint (rather than existential) for static dispatch
 - `RecipeListView.init` takes in a generic `Service` for easy DI

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
- 2hrs/day for three days.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
- Images aren't self-sizing. They're just hardcoded 50x50. I always elect to make images self-sizing, but I consistently receive pushback. I'm curious to know what y'all think.
- The project overview says "the app should consist of just one screen displaying the list of recipes", which I read as "we don't want you to load the `source_url` and show the actual recipe when a cell is tapped." I'm not sure if this is right, so if y'all do in fact want this functionality please let me know.

- Requirements ask for the entire list of results to be thrown out if a single recipe is malformed. I'm happy to do this, but I don't think it's a good UX. As an alternative, I built `FailableDecodable` to skip malformed results.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The following seem like overkill for a project of this size, but I'd consider them to be weak choices:
- `RecipeListView` doesn't support pagination
- Views don't support accessibility
- Views don't support UI Testing
- App doesn't support localization

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
