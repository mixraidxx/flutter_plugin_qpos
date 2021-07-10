package com.dspread.flutter_plugin_qpos;

import android.os.Parcel;
import android.os.Parcelable;

import org.jetbrains.annotations.NotNull;


public final class Tag implements Parcelable, Parcelable.Creator {
    private  String tag;
    private  String value;

    public static final Creator<Tag> CREATOR = new Creator<Tag>() {
        @Override
        public Tag createFromParcel(Parcel in) {
            return new Tag(in);
        }

        @Override
        public Tag[] newArray(int size) {
            return new Tag[size];
        }
    };

    @NotNull
    public final String getModelTag() {
        return this.tag;
    }

    @NotNull
    public final String getModelValue() {
        return this.value;
    }

    public Tag(String tag, String value){
        this.tag = tag;
        this.value = value;
    }

    public Tag(@NotNull Parcel parcel) {
        this(parcel.readString(), parcel.readString());
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(tag);
        parcel.writeString(value);
    }

    @Override
    public Tag createFromParcel(Parcel parcel) {
        return new Tag(parcel);
    }

    @Override
    public Tag[] newArray(int i) {
        return new Tag[0];
    }



   /* public void writeToParcel(@NotNull Parcel parcel, int flags) {
        Intrinsics.checkParameterIsNotNull(parcel, "parcel");
        parcel.writeString(this.tag);
        parcel.writeString(this.value);
    }

    public int describeContents() {
        return 0;
    }

    @NotNull
    public final String getTag() {
        return this.tag;
    }

    @NotNull
    public final String getValue() {
        return this.value;
    }

    public Tag(@NotNull String tag, @NotNull String value) {
        Intrinsics.checkParameterIsNotNull(tag, "tag");
        Intrinsics.checkParameterIsNotNull(value, "value");
        super();
        this.tag = tag;
        this.value = value;
    }

    public Tag(@NotNull Parcel parcel) {
        Intrinsics.checkParameterIsNotNull(parcel, "parcel");
        String var10001 = parcel.readString();
        Intrinsics.checkExpressionValueIsNotNull(var10001, "parcel.readString()");
        String var10002 = parcel.readString();
        Intrinsics.checkExpressionValueIsNotNull(var10002, "parcel.readString()");
        this(var10001, var10002);
    }

    @JvmStatic
    @NotNull
    public static Tag createFromParcel(@NotNull Parcel parcel) {
        return CREATOR.createFromParcel(parcel);
    }

    @JvmStatic
    @NotNull
    public static Tag[] newArray(int size) {
        return CREATOR.newArray(size);
    }

    @Metadata(
            mv = {1, 1, 16},
            bv = {1, 0, 3},
            k = 1,
            d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0010\u0010\u0004\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0006H\u0017J\u001d\u0010\u0007\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0017¢\u0006\u0002\u0010\u000b¨\u0006\f"},
            d2 = {"Lcom/dspread/flutter_plugin_qpos/Tag$CREATOR;", "Landroid/os/Parcelable$Creator;", "Lcom/dspread/flutter_plugin_qpos/Tag;", "()V", "createFromParcel", "parcel", "Landroid/os/Parcel;", "newArray", "", "size", "", "(I)[Lcom/dspread/flutter_plugin_qpos/Tag;", "android.flutter_plugin_qpos"}
    )
    public static final class CREATOR implements Creator {
        @JvmStatic
        @NotNull
        public Tag createFromParcel(@NotNull Parcel parcel) {
            Intrinsics.checkParameterIsNotNull(parcel, "parcel");
            return new Tag(parcel);
        }

        // $FF: synthetic method
        // $FF: bridge method
        public Object createFromParcel(Parcel var1) {
            return this.createFromParcel(var1);
        }

        @JvmStatic
        @NotNull
        public Tag[] newArray(int size) {
            return new Tag[size];
        }

        // $FF: synthetic method
        // $FF: bridge method
        public Object[] newArray(int var1) {
            return this.newArray(var1);
        }

        private CREATOR() {
        }

        // $FF: synthetic method
        public CREATOR(DefaultConstructorMarker $constructor_marker) {
            this();
        }
    }*/
}