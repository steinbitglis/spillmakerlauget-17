import UnityEngine

# import Boo.Lang.Compiler.Ast
# 
#  macro inline_enum (enumName as ReferenceExpression):
#  
#      ### --- Example of 'inline_enum' ---
#  
#      ### inline_enum direction:
#      ###     left
#      ###     right
#  
#      ### =>
#  
#      ### static public private final numDirections = 2
#      ### static private final left = 0
#      ### static private final right = 1
#  
#      numEnums = ReferenceExpression("num" + enumName.Name[0:1].ToUpper() + enumName.Name[1:] + "s")
#      yield [|
#          static public final $numEnums = $(len(inline_enum.Body.Statements))
#      |]
#  
#      for i as long, statement in enumerate(inline_enum.Body.Statements):
#          es = statement as ExpressionStatement
#  
#          #  expressions will end with '()',
#          #  because they're thought to be function calls
#          name = ReferenceExpression(es.Expression.ToString()[:-2])
#  
#          yield [|
#              static private final $name = $i
#          |]



[ExecuteInEditMode]
class Footman (MonoBehaviour):

    # ---   Implementation 1 ---
    enum EquipmentType:
        Hands
        Armor
        Shoes
        Gloves
    
    public belongings = array(string, System.Enum.GetValues(EquipmentType).Length)
    # --------------------------

    # ---   Implementation 2 ---
    # inline_enum EquipmentType:
    #     Hands
    #     Armor
    #     Shoes
    #     Gloves

    # public belongings = array(string, numEquipmentTypes)
    # --------------------------

    public canCarryMoreStuff = true
    public primaryEquipment = "No equipment primary yet"

    # ---   Implementation 1 ---
    def Update():
        primaryEquipment = belongings[EquipmentType.Hands]
        canCarryMoreStuff = false
        for i in range (System.Enum.GetValues(EquipmentType).Length):
            canCarryMoreStuff |= belongings[i] == ""
    # --------------------------

    # ---   Implementation 2 ---
    # def Update():
    #     primaryEquipment = belongings[Hands]
    #     canCarryMoreStuff = false
    #     for i in range (numEquipmentTypes):
    #         canCarryMoreStuff |= belongings[i] == ""
    # --------------------------
