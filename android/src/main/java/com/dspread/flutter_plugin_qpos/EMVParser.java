package com.dspread.flutter_plugin_qpos;

import android.util.Log;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import io.github.binaryfoo.DecodedData;
import io.github.binaryfoo.RootDecoder;
import kotlin.jvm.internal.Intrinsics;

public class EMVParser {
    private final RootDecoder _decoder = new RootDecoder();

    @NotNull
    public final ArrayList decodeTLV(@NotNull String emv) {
        Intrinsics.checkParameterIsNotNull(emv, "emv");
        return this.parseDecodedData(this._decoder.decode(emv, "EMV", "constructed"));
    }

    private final ArrayList parseDecodedData(List tagList) {
        ArrayList parcelable = new ArrayList();
        Tag tag = null;
        int i = 0;
        Collection var6 = (Collection)tagList;
        int var5 = var6.size() - 1;
        if (i <= var5) {
            while(true) {
                String tagNumber[] = ((DecodedData)tagList.get(i)).getRawData().split(" ");
                tag = new Tag(tagNumber[0], ((DecodedData)tagList.get(i)).getFullDecodedData());
                parcelable.add(tag);
                if (i == var5) {
                    break;
                }

                ++i;
            }
        }

        return parcelable;
    }
}
