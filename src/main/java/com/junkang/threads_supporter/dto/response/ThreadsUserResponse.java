package com.junkang.threads_supporter.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ThreadsUserResponse {

    private String id;

    private String username;

    @JsonProperty("threads_profile_picture_url")
    private String profilePictureUrl;

    @JsonProperty("threads_biography")
    private String biography;
}
