[y,xt] = libsvmread('../heart_scale');
w = load('../heart_scale.wgt');
model=train_liblinear_weights(w, y, xt);
[l,a]=predict_liblinear_weights(y, xt, model);

