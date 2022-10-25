package com.chrisdavid.lighttrak

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.chrisdavid.lighttrak.databinding.FragmentCreateAccountBinding

class CreateAccountFragment : Fragment() {

    private var _binding: FragmentCreateAccountBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View{

        _binding = FragmentCreateAccountBinding.inflate(inflater, container, false)
        binding.buttonSignUp.setOnClickListener {

        }
        return binding.root

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}