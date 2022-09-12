--[[
Create a node tree renderer

Example:

           [-]
           /|\
        [-][-][-]
        /|  |   \
     [-][-][-]   [-]
        /|
     [-][-]

To descend down the node tree, the nodes children property will contain the child nodes.
To ascend up the node tree, the nodes parent property will contain the parent node.
To store the nodes data, such as properties, the nodes data property should contain that information.

Each of the nodes propertys will be in sync with the element. This behavior allows every element to be dynamicly changed outside of where it was created. 
On of the major advantages to this is the ability to edit properties of a component outside of the component, which can be very powerful.

A table util module will be created so we dont have to use cryo, this means easyier table manipulation and such.
The table util module will conatin a SyncModify function this will allow you to create a new table which can be modified how ever, and each property will be in sync
with the original one.

Example:

    Node = {
        children = {
            TypeMarker(Node),
            TypeMarker(Node),
        },
        parent = TypeMarker(Node),
        data = {
            props = {
                Size = Udim2.new(0, 200, 0, 50),
                Position = Udim2.new(.5, 0, .5, 0),
                AnchorPoint = Vector2.new(.5, .5),
            },
            object = 'Roblox Instance'
        }      
    }

    newTable = TableUtil.SyncModify(Node, function(newTable, tbl)
        newTable.object = tbl.data.object
        for prop, value in pairs(tbl.data.props) do
            newTable[prop] = value
        end
        newTable.children = {}
        for i, child in pairs(tbl.children) do
            newTable.children[i] = child
        end
    end)

    newTable == {
        object = tbl.data.object,
        Size = Udim2.new(0, 200, 0, 50),
        Position = Udim2.new(.5, 0, .5, 0),
        AnchorPoint = Vector2.new(.5, .5),
    }

    newTable.Size = Udim2.new(0, 100, 0, 100)
    Node.data.props.Size == Udim2.new(0, 100, 0, 100)

    Node.data.props.Position = Udim2.new(.25, 0, .25, 0)
    newTable.Position == Udim2.new(.25, 0, .25, 0) 

]]