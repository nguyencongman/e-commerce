
const admin = require("firebase-admin")
const serviceAccount = require('../../../.firebase/e-commerce-flutter-75e59-firebase-adminsdk-fbsvc-6c1f663bfb.json')
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});


// Middleware để giải mã và xác thực ID token
const verifyToken= async(req, res,next) =>{
  const authHeader = req.headers.authorization ||'';
  console.log({authHeader});
  if(!authHeader.startsWith("Bearer")){
    return res.status(401).json({message:"Unauthorized"})
  }
  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decoded = await admin.auth().verifyIdToken(idToken);
    req.uid = decoded.uid;
    next();
  } catch (error) {
    console.log("token verify failed",error)
  }
}

module.exports={verifyToken}