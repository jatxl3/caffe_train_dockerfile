FROM jatxl3/caffe:cpu
LABEL maintainer tmpxx123@163.com

WORKDIR /workspace

RUN mkdir -p ./examples/mnist && \
    cp -ru $CAFFE_ROOT/examples/mnist/create_mnist.sh ./examples/mnist/ && \
    sed -i 's#BUILD=build#BUILD=\$CAFFE_ROOT/build##' ./examples/mnist/create_mnist.sh && \
    ./examples/mnist/create_mnist.sh

RUN cp $CAFFE_ROOT/examples/mnist/lenet_solver.prototxt ./examples/mnist/ && \
    cp $CAFFE_ROOT/examples/mnist/lenet_train_test.prototxt ./examples/mnist/ && \
    sed -i 's#solver_mode: GPU#solver_mode: CPU##' ./examples/mnist/lenet_solver.prototxt && \
    caffe train --solver=examples/mnist/lenet_solver.prototxt 2>&1 | tee train_lenet.log

