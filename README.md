# Thunder Table

Thunder Table is a useful framework which enables quick and easy creation of table views in iOS, making the process of creating complex tables as simple as a few lines of code; and removing the necessity for having long chains of index paths and if statements.

Thunder table comprises of two main types of objects;

## Rows

Table rows are objects that conform to the `TSCTableRowDataSource` protocol, this protocol has properties such as: title, subtitle and image which are responsible for providing the content to a table view cell. As this is a protocol any object can conform to it, which allows you to simply send an array of model objects to the table view to display your content.


# Installation

Setting up your app to use Thunder Table is a simple process and quick process once you have your app set up in the CMS. For now Thunder Table is built as a static framework, meaning you will need to include the whole Xcode project in your workspace.

+ Drag all included files and folders to a location within your existing project.
+ Add ThunderTable.framework to your Embedded Binaries.
+ Wherever you want to use ThunderTable use `@import ThunderTable` or `import ThunderTable` if you're using swift.

# Code Examples
## A Simple Table View

Setting up a table view is massively simplified using thunder table, in fact. We can get a simple table view running with just a few lines of code.

First we initialise the rows which we want to appear in our table view:

		
## Adding native content

And of course sometimes you'll want to have native content for an app, which is not supported under our CMS system, but still have it linked up to other pages in the CMS. To do this we can add the following before we initialise our TSCAppViewController:

		[TSCStormViewController registerNativePageName:@"native_page" toViewControllerClass:[TSCNativeViewController class]];
		
There are multiple ways to override the native behaviour of Thunder Cloud, more of which can be seen in the [Storm Demo Project](https://github.com/3sidedcube/iOS-Storm-Demo)

#License
See [LICENSE.md](LICENSE.md)
