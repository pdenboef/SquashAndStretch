using UnityEngine;

public class SquashAndStretch : MonoBehaviour
{
    private static readonly int SquashID = Shader.PropertyToID("_Squash");
    private static readonly int RadiusID = Shader.PropertyToID("_Radius");
    private static MaterialPropertyBlock _mpb;

    public Renderer Renderer;
    public float CollisionRadius = 0.5f;

    [Header("Constraints")]
    public float MaxSquash = 1.0f;

    [Header("Spring")]
    public float Strength = 15f;
    public float Dampening = 0.3f;
    public float VelocityStretch = 0.02f;

    private float _squash;
    private float _squashVelocity;
    private Vector3 _lastPosition;

    void Awake()
    {
        _lastPosition = transform.position;
    }

    void LateUpdate()
    {
        //If no MeshRenderer is selected then return.
        if (Renderer == null) return;

        //If _mpb is null then create a new Material Property Block.
        if (_mpb == null)
            _mpb = new MaterialPropertyBlock();

        //Calculate the velocity. Store the current position calculating the velocity next update.
        Vector3 velocity = (transform.position - _lastPosition) / Time.deltaTime;
        _lastPosition = transform.position;

        //Calculate the desired squash amount based on the current velocity.
        float targetSquash = velocity.magnitude * VelocityStretch;

        //Adjust the squash velocity.
        _squashVelocity += (targetSquash - _squash) * Strength * Time.deltaTime;

        //Apply dampening to the squash velocity.
        _squashVelocity = ((_squashVelocity / Time.deltaTime) * (1f - Dampening)) * Time.deltaTime;

        //Apply the velocity to the squash value.
        _squash += _squashVelocity;

        // Clip squash intensity to maximum value
        _squash = Mathf.Clamp(_squash, -MaxSquash, MaxSquash);

        //Update the material property block with the squash and radius value.
        _mpb.SetFloat(SquashID, _squash);
        _mpb.SetFloat(RadiusID, CollisionRadius);

        //Set the material property block on the MeshRenderer.
        Renderer.SetPropertyBlock(_mpb);
    }
}