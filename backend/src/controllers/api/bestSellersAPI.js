const model = require("../../models/bestSellerModel");

const getItems= async (req,res) => {
    try {
        const items = await model.getItems();
        return res.status(200).json({"message":"success","data":items})
    } catch (error) {
        return res.status(500).json({"error":error});
    }
}
module.exports={getItems};