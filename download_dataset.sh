#!/bin/bash

tar -xzvf SC_dataset.tar.gz
tar -xzvf SC_dataset_2.tar.gz

cd SC_dataset
mv * ../datasets
cd ..

cd SC_dataset_2
mv * ../datasets
cd ..

