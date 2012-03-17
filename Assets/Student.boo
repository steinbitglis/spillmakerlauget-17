import UnityEngine

# import Boo.Lang.Compiler.Ast

# macro hundred_of_these(e as ReferenceExpression):
#     for i in range(1, 101):
#         new_name = ReferenceExpression(e.Name + "_$i")
#         yield [|
#             public $new_name as int
#         |]
# 
# macro mood():
#     yield [|
#         if mood_for_a_date:
#             $(mood.Body.Statements[0])
#         else:
#             $(mood.Body.Statements[1])
#     |]

# macro inline_enum (enumName as ReferenceExpression):
#     numEnums = ReferenceExpression("num" + enumName.Name[0:1].ToUpper() + enumName.Name[1:] + "s")
#     yield [|
#         static public final $numEnums = $(len(inline_enum.Body.Statements))
#     |]
#     for i as long, statement in enumerate(inline_enum.Body.Statements):
#         es = statement as ExpressionStatement
#         # expressions will end with '()', or they would be unfit
#         name = ReferenceExpression(es.Expression.ToString()[:-2])
#         yield [|
#             static private final $name = $i
#         |]

[ExecuteInEditMode]
class Student (MonoBehaviour): 

    public mood_for_a_date = true
    public status = "Undecided"
    
    # hundred_of_these girls

    def Update():
        # ---   Implementation 1 ---
        if mood_for_a_date:
            status = "Happy"
        else:
            status = "Not - Happy!"
        # --------------------------

        #  --   Implementation 2 ---
        # mood:
        #     status = "Happy"
        #     status = "Not - Happy!"
        #   --------------------------
