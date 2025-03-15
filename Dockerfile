FROM dustynv/l4t-pytorch:r36.2.0 

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt update
RUN apt install -y git wget unzip software-properties-common vim tmux build-essential ffmpeg libsm6 libxext6
RUN apt install python3 python3-dev python3-venv
RUN pip install --upgrade pip

#3dlabelprop_setup
RUN apt -y install python3-pybind11 libmlpack-dev liblapack-dev libblas-dev libarmadillo-dev cmake libopenblas-dev \
    libsuperlu-dev libensmallen-dev #libarpack2-de libomp-dev libcereal-dev libstb-dev

# For linux/amd64
#RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh
#RUN bash Anaconda3-2023.03-1-Linux-x86_64.sh -b -u

#RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-aarch64.sh
#RUN bash Anaconda3-2023.03-1-Linux-aarch64.sh -b -u
#ENV PATH="/root/anaconda3/bin:$PATH"
#RUN conda init bash

#RUN eval "$(/root/anaconda3/bin/conda shell.bash hook)"
#RUN conda create -y -n env python=3.8

#SHELL ["conda", "run", "--no-capture-output", "-n", "env", "/bin/bash", "-c"]
RUN git clone https://github.com/DarthIV02/HyperLiDAR.git /home/HyperLiDAR

WORKDIR /home/HyperLiDAR

# Begin 3dlabelprop_setup content
#RUN curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz

#RUN tar -xf vscode_cli.tar.gz
#RUN conda install pytorch==2.4.1 torchvision==0.19.1 torchaudio cudatoolkit=11.0 -c pytorch
RUN pip install wheel

COPY requirements.txt requirements.txt
RUN yes | pip install -r requirements.txt --verbose
WORKDIR /home/HyperLiDAR/cpp_wrappers
RUN ls -l
RUN chmod +x compile_wrappers.sh
WORKDIR /home/HyperLiDAR
#RUN pip install --force-reinstall torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117
RUN pip install 'Cython<3'
RUN pip install protobuf==3.19.0
RUN pip install torch-hd
# torch-1.13.0a0+d0d6b1f2.nv22.10-cp38-cp38-linux_aarch64.whl
#RUN wget https://developer.download.nvidia.com/compute/redist/jp/v502/pytorch/torch-1.13.0a0+d0d6b1f2.nv22.10-cp38-cp38-linux_aarch64.whl -O torch-1.13.0a0+d0d6b1f2.nv22.10-cp38-cp38-linux_aarch64.whl && \
#    pip install torch-1.13.0a0+d0d6b1f2.nv22.10-cp38-cp38-linux_aarch64.whl
# torchvision-0.14.0a0+89e1c4d.nv22.10-cp38-cp38-linux_aarch64.whl
#RUN wget https://developer.download.nvidia.com/compute/redist/jp/v51/pytorch/torchvision-0.14.0a0+89e1c4d.nv22.10-cp38-cp38-linux_aarch64.whl -O torchvision-0.14.0a0+89e1c4d.nv22.10-cp38-cp38-linux_aarch64.whl && \
#    pip install torchvision-0.14.0a0+89e1c4d.nv22.10-cp38-cp38-linux_aarch64.whl
# torchvision-0.18.0a0+6043bc2-cp310-cp310-linux_aarch64.whl
#RUN wget https://nvidia.box.com/shared/static/xpr06qe6ql3l6rj22cu3c45tz1wzi36p.whl -O torchvision-0.18.0a0+6043bc2-cp310-cp310-linux_aarch64.whl && \
#    pip install torchvision-0.18.0a0+6043bc2-cp310-cp310-linux_aarch64.whl && \
#    rm torchvision-0.18.0a0+6043bc2-cp310-cp310-linux_aarch64.whl

RUN apt-get install libcudnn8 libcudnn8-dev libcudnn8-samples
RUN apt-get install -y libopenmpi-dev 



#WORKDIR /tmp
#RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
#RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
#RUN echo "deb https://apt.repos.intel.com/mkl all main" | tee /etc/apt/sources.list.d/intel-mkl.list
#RUN apt-get update && \
#    apt-get install -y intel-mkl-64bit-2018.2-046
#end 3dlabelprop_setup content
WORKDIR /home/HyperLiDAR

RUN git clone https://github.com/valeoai/WaffleIron
RUN command pip install -e WaffleIron/
RUN wget https://github.com/valeoai/ScaLR/releases/download/v0.1.0/info_datasets.tar.gz 
RUN tar -xvzf info_datasets.tar.gz
RUN rm info_datasets.tar.gz

RUN echo "conda activate env" >> /root/.bashrc
RUN echo "cd /home/HyperLiDAR && git pull && cd">> /root/.bashrc
RUN echo "echo Success" >> /root/.bashrc