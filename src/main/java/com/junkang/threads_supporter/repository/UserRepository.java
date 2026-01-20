package com.junkang.threads_supporter.repository;

import com.junkang.threads_supporter.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {

    Optional<User> findByThreadsUserId(String threadsUserId);

    Optional<User> findByUsername(String username);

    boolean existsByThreadsUserId(String threadsUserId);
}
