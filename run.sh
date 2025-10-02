# make sure to revise your_path_to_models to the paths of pretrained models

# generate a new image and save, or use your own
CUDA_VISIBLE_DEVICES=0 python image_generate_sdxl.py --prompt "" --output_file "" 

# generate warped images and save
# you will need a luciddreamer environment
CUDA_VISIBLE_DEVICES=0 python lucid.py --input_path "" --pcd_mode "" --out_dir "" --prompt ""

# turn warped images into latent
# different pretrained models have different schedules, here we use CogVideoX-2b as example
# use your own model's noise shedule, another example is in latent_svd.py
CUDA_VISIBLE_DEVICES=0 python latent.py --index 0 --warp_path ""

# generate video
# here use CogVideoX, example of using svd is in generate_svd.py

# before we generate video, there's one more important thing to do.
# because video models in diffusers only support generating from step T (nearly pure Gaussian noise),
# we need to do some minor revisions to the source code of video models in diffusers to allow it generate from the middle steps.
# but don't worry, there're only few changes.
# you need to be aware that if you reinstall the diffusers, these changes will be removed.
# revise the source code in diffusers is temporary but very quick!

# here's the steps: (Take SVD as example)
# find the source code of StableVideoDiffusionPipeline. for example your_envs_path/lib/python3.x/site_package/diffusers/src/diffusers/pipelines/cogvideo/pipeline_stable_video_diffusion.py. (or ctrl+click)
# find the __call__ of this class, and do 3 revisions:
# 1. add an input param: start_index: Optional[int]=None to the function.
# 2. add an if: "if latents is None:" before "latents = self.prepare_latents". 
# 3. change the loop "for i, t in enumerate(timesteps):" into "for i, t in enumerate(timesteps[start_index:])".
# you can refer to revised_svd.py for these changes.


CUDA_VISIBLE_DEVICES=0 python cli_demo.py --output_path "" --latents "" --prompt ""

# if you have any questions you could also refer to another repository
# https://github.com/LAARRRY/CamTrol

