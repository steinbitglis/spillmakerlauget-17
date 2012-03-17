import UnityEngine
import UnityEditor

[CustomEditor(Garage)]
class GarageEditor (Editor):

    carsProp as SerializedProperty

    def OnEnable():
        carsProp = serializedObject.FindProperty("cars")

    def OnInspectorGUI():

        #   ---   Implementation 1 ---
        #
        # EditorGUIUtility.LookLikeInspector()
        EditorGUILayout.PropertyField(carsProp, GUIContent("prop field cars"), true)
        #
        #   --------------------------

        #   ---   Implementation 2 ---
        # # EditorGUIUtility.LookLikeInspector()
        # end = carsProp.GetEndProperty()
        # while true:
        #     myRect = GUILayoutUtility.GetRect(0f, 32);
        #     showChildren = EditorGUI.PropertyField(myRect, carsProp)
        #     break if not myIterator.NextVisible(showChildren) or SerializedProperty.EqualContents(carsProp, end)
        #   --------------------------
