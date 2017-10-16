# Discussion:

__App Structure__:

The whole architecture is following MVVM pattern. 

__iTunes API__:

1. Data model is created in struct  for music item,  assumes all the listed fields are not nil, otherwise returns nil for initialising;
2. The API client exposes a function for fetching music data by artist name and number of items, can easily add calls with different retriving parameters.
3. The unit test is only created for API calls functions, it uses mocked URLSession and given json file.



___UI___:

1. Use `SnapKit` as auto layout  rendering engine, everytime regenerate constraints for elements when device orientation changes;
2. There are 3 basic UI elements (`SearchField`, `SongListTableView` and `PlayerControlView`), everytime rearrange those elements when orientation changes;
3. Create `viewModel`s for table view and the cell, and use them to manage data source and logic.



__Issues__:

Haven't time to implement music playing progress control, was thinking to use `SliderBar` to control/show playing progress.

