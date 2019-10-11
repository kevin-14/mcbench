export KMP_BLOCKTIME=30
export KMP_SETTINGS=1
export KMP_AFFINITY="granularity=fine,verbose,compact,1,0"

perfcounter=uncore_imc_0/cas_count_read/,uncore_imc_0/cas_count_write/,uncore_imc_1/cas_count_read/,uncore_imc_1/cas_count_write/,uncore_imc_2/cas_count_read/,uncore_imc_2/cas_count_write/,uncore_imc_3/cas_count_read/,uncore_imc_3/cas_count_write/,uncore_imc_4/cas_count_read/,uncore_imc_4/cas_count_write/,uncore_imc_5/cas_count_read/,uncore_imc_5/cas_count_write/


path=resnext_threads_2sockets_upi_xeon
mkdir $path

for bs in 1 16 256
do

mklthread=24
asyncthread=1
name=mklthread_${mklthread}-asyncthread_${asyncthread}-batchsize_$bs
MKL_NUM_THREADS=$mklthread OMP_NUM_THREADS=$mklthread python imagenet_trainer.py --use_cpu --train_data null --batch_size $bs --async_threads $asyncthread &
pid=$!
sleep 30
perf stat -a -e $perfcounter -o $path/$name.err -p $pid -I 1000 sleep 60 
kill $pid

mklthread=12
asyncthread=2
name=mklthread_${mklthread}-asyncthread_${asyncthread}-batchsize_$bs
MKL_NUM_THREADS=$mklthread  OMP_NUM_THREADS=$mklthread python imagenet_trainer.py --use_cpu --train_data null --batch_size $bs --async_threads $asyncthread &
pid=$!
sleep 30
perf stat -e $PERF_COUNTERS -o $path/$name.err -p $pid sleep 60 
kill $pid

mklthread=8
asyncthread=3
name=mklthread_${mklthread}-asyncthread_${asyncthread}-batchsize_$bs
MKL_NUM_THREADS=$mklthread  OMP_NUM_THREADS=$mklthread python imagenet_trainer.py --use_cpu --train_data null --batch_size $bs --async_threads $asyncthread &
pid=$!
sleep 30
perf stat -e $PERF_COUNTERS -o $path/$name.err -p $pid sleep 60 
kill $pid

mklthread=6
asyncthread=4
name=mklthread_${mklthread}-asyncthread_${asyncthread}-batchsize_$bs
MKL_NUM_THREADS=$mklthread  OMP_NUM_THREADS=$mklthread python imagenet_trainer.py --use_cpu --train_data null --batch_size $bs --async_threads $asyncthread &
pid=$!
sleep 30
perf stat -e $PERF_COUNTERS -o $path/$name.err -p $pid sleep 60 
kill $pid
 
done
