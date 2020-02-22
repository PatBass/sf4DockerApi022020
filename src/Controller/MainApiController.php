<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\JsonResponse;

class MainApiController extends AbstractController
{
    /**
     * @Route("/main/api", name="main_api")
     */
    public function index()
    {
    	$data = [
    		'name' => 'iPhone X',
    		'price' => 1000
    	];
        /*return $this->render('main_api/index.html.twig', [
            'controller_name' => 'MainApiController',
        ]);*/
        return new JsonResponse($data);
    }
}
