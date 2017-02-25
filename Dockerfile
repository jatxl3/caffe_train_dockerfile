FROM jatxl3/caffe:cpu
LABEL maintainer tmpxx123@163.com

WORKDIR /workspace

RUN cat /proc/cpuinfo

RUN mkdir -p ./data/cifar10 && \
    cp -ru $CAFFE_ROOT/data/cifar10/get_cifar10.sh ./data/cifar10/ && \
    ./data/cifar10/get_cifar10.sh

RUN mkdir -p ./examples/cifar10 && \
    cp -ru $CAFFE_ROOT/examples/cifar10/create_cifar10.sh ./examples/cifar10/ && \
    sed -i 's#./build#\$CAFFE_ROOT/build##' ./examples/cifar10/create_cifar10.sh && \
    ./examples/cifar10/create_cifar10.sh

RUN du -sh *

RUN cp $CAFFE_ROOT/examples/cifar10/cifar10_full_solver*.prototxt ./examples/cifar10/ && \
    cp $CAFFE_ROOT/examples/cifar10/cifar10_full_train_test.prototxt ./examples/cifar10/ && \
    sed -i 's#solver_mode: GPU#solver_mode: CPU##' ./examples/cifar10/cifar10_full_solver.prototxt

RUN caffe train --solver=examples/cifar10/cifar10_full_solver.prototxt 2>&1 | tee train_cifar10_full.log

RUN caffe train \
    --solver=examples/cifar10/cifar10_full_solver_lr1.prototxt \
    --snapshot=examples/cifar10/cifar10_full_iter_60000.solverstate.h5 2>&1 | tee train_cifar10_full_lr1.log

RUN caffe train \
    --solver=examples/cifar10/cifar10_full_solver_lr2.prototxt \
    --snapshot=examples/cifar10/cifar10_full_iter_65000.solverstate.h5 2>&1 | tee train_cifar10_full_lr2.log

