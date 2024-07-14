# 2.6.4
* Fixed a couple component bugs

# 2.6.3
* Fixed/Improved Component:setState()
* Vision.None + Vision.Types added

# 2.6.2
* Safer way of accessing apps components

# 2.6.1
* Safer way of accessing apps components

# 2.6.0
* Much better way to deal with creating apps inside of components

# 2.5.0
* New way to create Vision apps
* Component state compatibility

# 2.4.0
* Size and Position can now be assigned a function and will update the property of what ever the function returns everytime the cameras ViewportSize changes.

# 2.3.4
* Fixed components erroring when assigned a ref property when an elementGroup is rendered.
* All of the component methods get called with the props and children property.

# 2.3.3
* Fixed old props in components being applied when updated.
* Updated some internal code.

# 2.3.2
* Fixed updated props in components not being aplied when updated.

# 2.3.1
* Fixed bugs revolving around Refs.

# 2.3.0
* [Vision.App] - now returns the internal component.
* Vision.createApp() - is now a dynamicValue that is set to the internal component on the mounting process.
* The Size property of an element will be applied whenever the workspace.Camera.ViewportSize is changed, if the value is a function.

# 2.2.0
* [Vision.Ref] is now auto asigned to components unless overwriten.
* Vision.createApp() - Allows you to create a public interface for components.
* [Vision.App] - Must be Vision.createApp() or a table.

# 2.1.0
* [Vision.Ref] now accepts functions. The reference is passed as the first argument of the function.

# 2.0.0
* Cascade values are now merged with props in functions and components.
* Component:update() is now Component:rerender().
* New Component:beforeRerender() and Component:onRerender() methods.

# 1.1.2
* Vision.Enviroment includes all of the mounted trees per script.

# 1.1.0 - 1.1.1
* Ignored due to an issue with wally