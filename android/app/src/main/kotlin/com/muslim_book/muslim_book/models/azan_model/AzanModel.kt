package com.muslim_book.muslim_book.models.azan_model

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName

class AzanModel {
    @SerializedName("code")
    @Expose
    private var code: Int? = null

    @SerializedName("status")
    @Expose
    private var status: String? = null

    @SerializedName("data")
    @Expose
    private var data: List<AzanModelData>? = null

    fun getCode(): Int? {
        return code
    }

    fun setCode(code: Int?) {
        this.code = code
    }

    fun getStatus(): String? {
        return status
    }

    fun setStatus(status: String?) {
        this.status = status
    }

    fun getData(): List<AzanModelData>? {
        return data
    }

    fun setData(data: List<AzanModelData>?) {
        this.data = data
    }
}