import UnityEngine
import UnityEditor
import System.IO

[CustomEditor(ZPositionLocker)]
class ZPositionLockerEditor (Editor):

    [MenuItem("Spillmakerlauget/Create the z-position locking config")]
    static def EnableZPosLocking():
        LoadZLocker()

    static zpos_locker as ZPositionLocker:
        get:
            LoadZLocker()
            return _zpos_locker
    static _zpos_locker as ZPositionLocker

    static def LoadZLocker():
        unless _zpos_locker:
            _zpos_locker = AssetDatabase.LoadAssetAtPath("Assets/Resources/Editor/Z-Position Locker.asset", ZPositionLocker)
            unless _zpos_locker:
                unless Directory.Exists("Assets/Resources"):
                    AssetDatabase.CreateFolder("Assets", "Resources")
                unless Directory.Exists("Assets/Resources/Editor"):
                    AssetDatabase.CreateFolder("Assets/Resources", "Editor")
                _zpos_locker = ScriptableObject.CreateInstance of ZPositionLocker()
                AssetDatabase.CreateAsset(_zpos_locker, "Assets/Resources/Editor/Z-Position Locker.asset")

    static def constructor():
        temp_zpos_locker = AssetDatabase.LoadAssetAtPath("Assets/Resources/Editor/Z-Position Locker.asset", ZPositionLocker)
        if temp_zpos_locker and temp_zpos_locker.zLocking:
            old_delegate = SceneView.onSceneGUIDelegate
            pcu = ZPositionLockerUpdate as SceneView.OnSceneFunc

            if old_delegate:
                unless pcu in old_delegate.GetInvocationList():
                    SceneView.onSceneGUIDelegate = System.Delegate.Combine(old_delegate, pcu)
            else:
                SceneView.onSceneGUIDelegate = pcu

    static def ZPositionLockerUpdate(sceneView as SceneView):
        if Event.current.type == EventType.DragPerform:
            newObjects = System.Collections.Generic.List of GameObject()
            for r in DragAndDrop.objectReferences:
                o = EditorUtility.InstantiatePrefab(r)
                newObjects.Add(o)

                go = o as GameObject
                zeroGround = 0f
                customDepth = go.GetComponent("CustomDepth") as CustomDepth
                if customDepth:
                    zeroGround = customDepth.Depth()

                ccam = Camera.current
                mouseRay = ccam.ScreenPointToRay(Vector3(Event.current.mousePosition.x, ccam.pixelHeight - Event.current.mousePosition.y, 0.0f))
                if mouseRay.direction.z > 0.0f:
                    t = -mouseRay.origin.z / mouseRay.direction.z
                    mouseWorldPos = mouseRay.origin + t * mouseRay.direction
                    mouseWorldPos.z = zeroGround
                    go.transform.position = mouseWorldPos

            if self.zpos_locker.selectsNewObjects:
                Selection.objects = newObjects.ToArray()
            Event.current.Use()
            DragAndDrop.AcceptDrag()

    zLockingProp as SerializedProperty
    selectsNewObjectsProp as SerializedProperty

    def OnEnable():
        zLockingProp = serializedObject.FindProperty("zLocking")
        selectsNewObjectsProp = serializedObject.FindProperty("selectsNewObjects")

    override def OnInspectorGUI():
        serializedObject.Update()

        pcu = ZPositionLockerUpdate as SceneView.OnSceneFunc
        old_delegate = SceneView.onSceneGUIDelegate

        count = 0
        total = 0
        if old_delegate:
            for i in old_delegate.GetInvocationList():
                total += 1
                if i.Equals(pcu):
                    count += 1

        EditorGUIUtility.LookLikeControls(160)

        # EditorGUILayout.LabelField("Active delegates",  "$count vs $total")

        hasActiveDelegates = count > 0
        GUI.enabled = wantActiveDelegates = EditorGUILayout.Toggle("Z-position locking", hasActiveDelegates)

        zLockingProp.boolValue = wantActiveDelegates

        if wantActiveDelegates != hasActiveDelegates:
            if wantActiveDelegates:
                if old_delegate:
                    unless pcu in old_delegate.GetInvocationList():
                        SceneView.onSceneGUIDelegate = System.Delegate.Combine(old_delegate, pcu)
                else:
                    SceneView.onSceneGUIDelegate = pcu
            else:
                if old_delegate:
                    SceneView.onSceneGUIDelegate = System.Delegate.RemoveAll(old_delegate, pcu)

        EditorGUILayout.PropertyField(selectsNewObjectsProp, GUIContent("Select newly created objects"))

        serializedObject.ApplyModifiedProperties()
