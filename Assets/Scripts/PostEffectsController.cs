using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostEffectsController : MonoBehaviour
{
    public Shader postShader;
    Material postEffectMaterial;
    public Camera distortionCamera;
    public float distortionIntensity;

    //make it start
    private void Awake(){
        postEffectMaterial = new Material(postShader);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest){
        int width = src.width;
        int height = src.height;

        RenderTexture startRenderTexture = RenderTexture.GetTemporary(width, height, 0, src.format);
        RenderTexture distortRenderTexture = RenderTexture.GetTemporary(width, height, 0, src.format);

        OnDistort(distortRenderTexture);
        postEffectMaterial.SetTexture("_DistortionTexture", distortRenderTexture);
        postEffectMaterial.SetFloat("_DistortionIntensity", distortionIntensity);

        Graphics.Blit(src, startRenderTexture, postEffectMaterial, 0);
        Graphics.Blit(startRenderTexture, dest);

        RenderTexture.ReleaseTemporary(startRenderTexture);
        RenderTexture.ReleaseTemporary(distortRenderTexture);
    }
    void OnDistort(RenderTexture renderTexture){
        if(distortionCamera == null){
            return;
        }
        distortionCamera.targetTexture = renderTexture;
        distortionCamera.Render();
    }
}
