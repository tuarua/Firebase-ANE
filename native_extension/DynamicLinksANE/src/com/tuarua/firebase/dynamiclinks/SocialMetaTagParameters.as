/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.firebase.dynamiclinks {
public final class SocialMetaTagParameters {
    /** <p>The description to use when the Dynamic Link is shared in a social post.</p> */
    public var description:String;
    /** <p>The URL to an image related to this link. The image should be at least 300x200 px, and
     * less than 300 KB</p> */
    public var imageUrl:String;
    /** <p>The title to use when the Dynamic Link is shared in a social post.</p> */
    public var title:String;

    public function SocialMetaTagParameters(description:String = null,
                                            imageUrl:String = null,
                                            title:String = null) {
        this.description = description;
        this.imageUrl = imageUrl;
        this.title = title;
    }
}
}
