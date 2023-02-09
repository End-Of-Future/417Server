--圣光飞龙的圣灵
function c27819043.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c27819043.synlimit)
	c:RegisterEffect(e1) 
	--revive
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(27819043,1)) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27819043) 
	e2:SetTarget(c27819043.sptg1)
	e2:SetOperation(c27819043.spop1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(27819043,2)) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27819043) 
	e2:SetTarget(c27819043.sptg2)
	e2:SetOperation(c27819043.spop2)
	c:RegisterEffect(e2)
end 
c27819043.SetCard_XXLight=true   
c27819043.SetCard_XXLightDragon=true 
function c27819043.synlimit(e,c)
	if not c then return false end
	return not c.SetCard_XXLight 
end 
function c27819043.desfil(c,tp) 
	return c:IsFaceup() and c.SetCard_XXLight and Duel.GetMZoneCount(tp,c)>0	
end 
function c27819043.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819043.desfil,tp,LOCATION_ONFIELD,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c27819043.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27819043.desfil,tp,LOCATION_ONFIELD,0,nil,tp) 
	if g:GetCount()<=0 then return end 
	local dg=g:Select(tp,1,1,nil)  
	if Duel.Destroy(dg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	if Duel.GetTurnPlayer()~=tp then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	end 
	end
end
function c27819043.rmfil(c) 
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c.SetCard_XXLight  
end 
function c27819043.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819043.rmfil,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c27819043.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27819043.rmfil,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()<=0 then return end 
	local rg=g:Select(tp,1,1,nil)  
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	if Duel.GetTurnPlayer()~=tp then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	end 
	end
end










