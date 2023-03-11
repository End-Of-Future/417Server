--超高校级·幸运
function c88882103.initial_effect(c)
	c:SetSPSummonOnce(88882103)
	--link summon
	aux.AddLinkProcedure(c,c88882103.matfilter,1,1)
	c:EnableReviveLimit() 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88882103,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetTarget(c88882103.sptg)
	e1:SetOperation(c88882103.spop)
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c88882103.tgtg)
	e2:SetValue(c88882103.tgval)
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c88882103.tgtg)
	e3:SetValue(500)
	c:RegisterEffect(e3) 
end
c88882103.ACGXJre=true 
function c88882103.matfilter(c) 
	return c.ACGXJre 
end 
function c88882103.xspfil(c,e,tp)
	return c:IsCode(88882102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
end
function c88882103.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88882103.xspfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c88882103.xspfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0) 
end
function c88882103.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then   
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
	end 
end
function c88882103.tgtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
function c88882103.tgval(e,re,rp)
	return rp==1-e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end 







